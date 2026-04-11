function _tide_item_vcs
    if not command -sq jj
        _tide_item_git
        return
    end

    if not jj root --quiet >/dev/null 2>/dev/null
        _tide_item_git
        return
    end

    set -l change_id
    jj log -r @ --no-graph -T 'change_id.shortest()' 2>/dev/null | read -l change_id
    test -n "$change_id"; or return

    set -l summary (jj diff --summary -r @ --ignore-working-copy 2>/dev/null)
    set -l added (string match -r '^A ' $summary | count)
    set -l modified (string match -r '^M ' $summary | count)
    set -l removed (string match -r '^D ' $summary | count)
    set -l renamed (string match -r '^R ' $summary | count)
    set -l copied (string match -r '^C ' $summary | count)
    set -l conflicts (jj resolve -r @ --list --ignore-working-copy 2>/dev/null | count)

    set -g tide_vcs_bg_color $tide_git_bg_color
    if test $conflicts -gt 0
        set -g tide_vcs_bg_color $tide_git_bg_color_urgent
    else if test (math "$added + $modified + $removed + $renamed + $copied") -gt 0
        set -g tide_vcs_bg_color $tide_git_bg_color_unstable
    end

    set -l bookmark
    set -l bookmark_color

    # 1) Current changeset bookmark
    set -l current_bookmarks (jj log -r @ --no-graph -T 'bookmarks' 2>/dev/null | string split ' ' | string match -rv '^$')
    if test (count $current_bookmarks) -gt 0
        set bookmark $current_bookmarks[1]
        if contains -- main@origin $current_bookmarks
            set bookmark main@origin
        end
        set bookmark_color $tide_git_color_branch
    end

    # 2) Closest parent bookmark (direct parent first, then nearest ancestor)
    if test -z "$bookmark"
        set -l parent_bookmarks (jj log -r '@-' --no-graph -T 'bookmarks' 2>/dev/null | string split ' ' | string match -rv '^$')
        if test (count $parent_bookmarks) -eq 0
            set parent_bookmarks (jj log -r 'heads(::@- & bookmarks())' --no-graph -n 1 -T 'bookmarks' 2>/dev/null | string split ' ' | string match -rv '^$')
        end

        if test (count $parent_bookmarks) -gt 0
            set bookmark $parent_bookmarks[1]
            if contains -- main@origin $parent_bookmarks
                set bookmark main@origin
            else
                for b in $parent_bookmarks
                    if string match -qr '@origin$' -- $b
                        set bookmark $b
                        break
                    end
                end
            end
            set bookmark_color $tide_git_color_staged
        end
    end

    # 3) Closest child bookmark
    if test -z "$bookmark"
        set -l child_bookmarks (jj log -r 'roots(@+:: & bookmarks())' --no-graph -n 1 -T 'bookmarks' 2>/dev/null | string split ' ' | string match -rv '^$')
        if test (count $child_bookmarks) -gt 0
            set bookmark $child_bookmarks[1]
            if contains -- main@origin $child_bookmarks
                set bookmark main@origin
            end
            set bookmark_color $tide_git_color_untracked
        end
    end

    _tide_print_item vcs $_tide_location_color$tide_vcs_icon' ' (set_color white; echo -ns $tide_vcs_changeset_icon' '$change_id
        if test -n "$bookmark"
            set_color $bookmark_color; echo -ns ' '$tide_vcs_bookmark_icon' '$bookmark
        end
        if test $added -gt 0
            set_color $tide_git_color_staged; echo -ns ' '$tide_vcs_change_added_icon' '$added
        end
        if test $modified -gt 0
            set_color $tide_git_color_dirty; echo -ns ' '$tide_vcs_change_modified_icon' '$modified
        end
        if test $removed -gt 0
            set_color $tide_git_color_conflicted; echo -ns ' '$tide_vcs_change_removed_icon' '$removed
        end
        if test $renamed -gt 0
            set_color $tide_git_color_upstream; echo -ns ' '$tide_vcs_change_renamed_icon' '$renamed
        end
        if test $copied -gt 0
            set_color $tide_git_color_untracked; echo -ns ' '$tide_vcs_change_copied_icon' '$copied
        end
        if test $conflicts -gt 0
            set_color $tide_git_color_conflicted; echo -ns ' '$tide_vcs_change_conflicted_icon' '$conflicts
        end)
end
