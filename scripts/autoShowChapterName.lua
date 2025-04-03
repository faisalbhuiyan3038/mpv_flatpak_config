local function showChapterTitle()
	local chapterTitle = mp.get_property_osd("chapter-metadata/by-key/title")
	mp.osd_message(chapterTitle, 10)
end

mp.observe_property("chapter", nil, showChapterTitle)