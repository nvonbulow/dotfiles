import { complete, type Message } from "@mariozechner/pi-ai";
import { convertToLlm, serializeConversation, type SessionEntry } from "@mariozechner/pi-coding-agent";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const SYSTEM_PROMPT = `You answer side-questions about an ongoing coding session.

Rules:
- Be concise by default.
- Prefer 1-3 bullets.
- Focus only on answering the side question from the provided session context.
- Do not propose taking over the main task.
- If context is insufficient, say so briefly.`;

export default function btwExtension(pi: ExtensionAPI) {
	let jobCounter = 0;

	pi.registerCommand("btw-clear", {
		description: "Clear the BTW widget/status",
		handler: async (_args, ctx) => {
			ctx.ui.setWidget("btw", undefined);
			ctx.ui.setStatus("btw", "");
			ctx.ui.notify("Cleared BTW widget", "info");
		},
	});

	pi.registerCommand("btw", {
		description: "Ask a side question in parallel without adding the reply to chat context",
		handler: async (args, ctx) => {
			if (!ctx.model) {
				ctx.ui.notify("No model selected", "error");
				return;
			}

			let question = args.trim();
			if (!question) {
				const typed = await ctx.ui.input("/btw", {
					prompt: "What do you want to ask about the current session?",
					placeholder: "e.g. why are we changing this module?",
				});
				question = (typed ?? "").trim();
			}

			if (!question) {
				ctx.ui.notify("Usage: /btw <question>", "warning");
				return;
			}

			const branch = ctx.sessionManager.getBranch();
			const messages = branch
				.filter((entry): entry is SessionEntry & { type: "message" } => entry.type === "message")
				.map((entry) => entry.message);

			const llmMessages = convertToLlm(messages);
			const conversationText = serializeConversation(llmMessages);
			const model = ctx.model;
			const jobId = ++jobCounter;

			ctx.ui.notify(`Running /btw #${jobId} in parallel...`, "info");
			ctx.ui.setStatus("btw", `BTW #${jobId}: thinking...`);

			void (async () => {
				try {
					const auth = await ctx.modelRegistry.getApiKeyAndHeaders(model);
					if (!auth.ok || !auth.apiKey) {
						throw new Error(auth.ok ? `No API key for ${model.provider}` : auth.error);
					}

					const userMessage: Message = {
						role: "user",
						content: [
							{
								type: "text",
								text: `Session context:\n\n${conversationText}\n\nSide question:\n\n${question}`,
							},
						],
						timestamp: Date.now(),
					};

					const response = await complete(
						model,
						{ systemPrompt: SYSTEM_PROMPT, messages: [userMessage] },
						{ apiKey: auth.apiKey, headers: auth.headers },
					);

					if (response.stopReason === "aborted") {
						ctx.ui.setStatus("btw", `BTW #${jobId}: cancelled`);
						ctx.ui.notify(`BTW #${jobId} cancelled`, "info");
						return;
					}

					const answer = response.content
						.filter((c): c is { type: "text"; text: string } => c.type === "text")
						.map((c) => c.text)
						.join("\n")
						.trim();

					ctx.ui.setWidget("btw", [
						`BTW #${jobId}`,
						`Q: ${question}`,
						"",
						"A:",
						...(answer ? answer.split("\n") : ["(no response)"]),
					]);
					ctx.ui.setStatus("btw", `BTW #${jobId}: done`);
					ctx.ui.notify(`BTW #${jobId} ready (shown in widget)`, "success");
				} catch (error) {
					const message = error instanceof Error ? error.message : String(error);
					ctx.ui.setStatus("btw", `BTW #${jobId}: failed`);
					ctx.ui.notify(`BTW #${jobId} failed: ${message}`, "error");
				}
			})();
		},
	});
}
