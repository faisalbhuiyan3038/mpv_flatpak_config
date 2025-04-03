function strip_html_tags(subtitle)
    local stripped_subtitle = subtitle:gsub("<[^>]+>", "")
    return stripped_subtitle
end

function on_sub_text(name, data)
    if data then
        local stripped_subtitle = strip_html_tags(data)
        mp.set_property("osd-msg3", stripped_subtitle)
    end
end

mp.register_event("file-loaded", function()
    mp.observe_property("sub-text", "string", on_sub_text)
end)
