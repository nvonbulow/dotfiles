function _tide_item_vcs
    # Set _tide_location_color which tide normally sets only when 'git' is in the items list.
    # We replaced 'git' with 'vcs', so we must set it ourselves.
    set_color $tide_git_color_branch | read -gx _tide_location_color

    # Detect jj repo by walking parent dirs (deepest first) for .jj/
    for i in (seq (count $_tide_parent_dirs) -1 1)
        if test -d "$_tide_parent_dirs[$i]/.jj"
            _tide_vcs_jj
            return
        end
    end

    # Fall back to the original tide git item
    _tide_item_git
end

function _tide_vcs_jj
    # Metadata: change_id, bookmarks, conflicted file count, divergent, description
    set -l jj_info (jj log -r '@' --no-graph --ignore-working-copy -T \
        'change_id.shortest() ++ "\n" ++ bookmarks.map(|b| b.name()).join(",") ++ "\n" ++ self.conflicted_files().len() ++ "\n" ++ if(divergent, "divergent", "") ++ "\n" ++ description.first_line()' \
        2>/dev/null)
    or return

    set -l change_id $jj_info[1]
    set -l bookmarks $jj_info[2]

    # File changes from jj diff --summary (snapshots working copy for live state)
    set -l diff_lines (jj diff --summary 2>/dev/null)

    # Parse counts using same regex pattern as tide's git item:
    # (0|(?<name>...)) makes the named group empty when count is 0
    string match -qr '(0|(?<conflicted>.*))\n(0|(?<added>.*))\n(0|(?<modified>.*))\n(0|(?<deleted>.*))' \
        "$(echo $jj_info[3]
        string match -r '^A ' $diff_lines | count
        string match -r '^M ' $diff_lines | count
        string match -r '^D ' $diff_lines | count)"

    set -l divergent $jj_info[4]
    set -l description $jj_info[5]

    # Set bg color based on state
    if test -n "$conflicted"
        set -g tide_jj_bg_color $tide_jj_bg_color_urgent
    else if test -n "$added$modified$deleted"
        set -g tide_jj_bg_color $tide_jj_bg_color_unstable
    end

    # Build the display (matches git item pattern: symbol + count, empty when 0)
    # Icons: f40c=alert_fill f457=diff_added f459=diff_modified f458=diff_removed f47a=bookmark_fill f417=git_commit
    _tide_print_item jj $tide_jj_icon' ' (
        if test -n "$bookmarks"
            set_color $tide_jj_color_bookmark
            echo -ns \uf47a' '$bookmarks' '
        end
        set_color $tide_jj_color_change_id
        echo -ns \uf417' '$change_id
        if test -n "$description"
            set_color $tide_jj_color_description
            echo -ns ' '(string shorten -m$tide_jj_truncation_length -- $description)
        end
        if test -n "$conflicted"
            set_color $tide_jj_color_conflict; echo -ns ' '\uf40c' '$conflicted
        end
        if test -n "$added"
            set_color $tide_jj_color_added; echo -ns ' '\uf457' '$added
        end
        if test -n "$modified"
            set_color $tide_jj_color_modified; echo -ns ' '\uf459' '$modified
        end
        if test -n "$deleted"
            set_color $tide_jj_color_deleted; echo -ns ' '\uf458' '$deleted
        end
        if test -n "$divergent"
            set_color $tide_jj_color_divergent
            echo -ns ' D'
        end
    )
end
