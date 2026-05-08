# Exhaustive `jj` Command Tree (Scanned)

Source: local `jj 0.40.0` help pages, recursively scanned (`jj --help`, then `<cmd> --help`, then subcommands).

Total scanned help pages: **114**.

## Top-level and subcommands

```text
jj
├─ abandon
├─ absorb
├─ arrange
├─ bisect
│  └─ run
├─ bookmark
│  ├─ advance
│  ├─ create
│  ├─ delete
│  ├─ forget
│  ├─ list
│  ├─ move
│  ├─ rename
│  ├─ set
│  ├─ track
│  └─ untrack
├─ commit
├─ config
│  ├─ edit
│  ├─ get
│  ├─ list
│  ├─ path
│  ├─ set
│  └─ unset
├─ describe
├─ diff
├─ diffedit
├─ duplicate
├─ edit
├─ evolog
├─ file
│  ├─ annotate
│  ├─ chmod
│  ├─ list
│  ├─ search
│  ├─ show
│  ├─ track
│  └─ untrack
├─ fix
├─ gerrit
│  └─ upload
├─ git
│  ├─ clone
│  ├─ colocation
│  │  ├─ disable
│  │  ├─ enable
│  │  └─ status
│  ├─ export
│  ├─ fetch
│  ├─ import
│  ├─ init
│  ├─ push
│  ├─ remote
│  │  ├─ add
│  │  ├─ list
│  │  ├─ remove
│  │  ├─ rename
│  │  └─ set-url
│  └─ root
├─ interdiff
├─ log
├─ metaedit
├─ new
├─ next
├─ operation
│  ├─ abandon
│  ├─ diff
│  ├─ integrate
│  ├─ log
│  ├─ restore
│  ├─ revert
│  └─ show
├─ parallelize
├─ prev
├─ rebase
├─ redo
├─ resolve
├─ restore
├─ revert
├─ root
├─ show
├─ sign
├─ simplify-parents
├─ sparse
│  ├─ edit
│  ├─ list
│  ├─ reset
│  └─ set
├─ split
├─ squash
├─ status
├─ tag
│  ├─ delete
│  ├─ list
│  └─ set
├─ undo
├─ unsign
├─ util
│  ├─ completion
│  ├─ config-schema
│  ├─ exec
│  ├─ gc
│  ├─ install-man-pages
│  ├─ markdown-help
│  └─ snapshot
├─ version
└─ workspace
   ├─ add
   ├─ forget
   ├─ list
   ├─ rename
   ├─ root
   └─ update-stale
```

## Notable “easy to miss” commands

- History surgery: `arrange`, `parallelize`, `simplify-parents`, `duplicate`, `metaedit`.
- Evolution diffing: `evolog`, `interdiff`.
- Recovery depth: `operation diff/show/revert/restore`.
- Workspace fleet management: `workspace add/update-stale`.
- Sparse working copy: `sparse set/edit`.
- Automation hooks: `fix`, `bisect run`, `util exec`, `util snapshot`.
