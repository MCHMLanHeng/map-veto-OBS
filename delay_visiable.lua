obs = obslua

-- 脚本的默认设置
settings = {
    sources = "",
    reverse_sources = "",
    delay = 1000
}

-- 记录当前状态
sequence_running = false
current_index = 1
source_names = {}
reverse_source_names = {}
show_hotkey_id = obs.OBS_INVALID_HOTKEY_ID
hide_hotkey_id = obs.OBS_INVALID_HOTKEY_ID

function script_description()
    return "This script toggles the visibility of specified scene items in sequence with a delay."
end

function script_update(set)
    settings.sources = obs.obs_data_get_string(set, "sources")
    settings.reverse_sources = obs.obs_data_get_string(set, "reverse_sources")
    settings.delay = obs.obs_data_get_int(set, "delay")
    print("Updated sources: " .. settings.sources)
    print("Updated reverse sources: " .. settings.reverse_sources)
    print("Updated delay: " .. settings.delay)
end

function script_properties()
    local props = obs.obs_properties_create()
    
    obs.obs_properties_add_text(props, "sources", "Sources (comma separated)", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_text(props, "reverse_sources", "Reverse Sources (comma separated)", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_int(props, "delay", "Delay (milliseconds)", 0, 10000, 100)
    obs.obs_properties_add_button(props, "show_button", "Show Sequence", show_sequence)
    obs.obs_properties_add_button(props, "hide_button", "Hide Sequence", hide_sequence)
    
    return props
end

function show_sequence()
    if sequence_running then
        print("Sequence already running")
        return
    end
    
    sequence_running = true
    print("Starting show sequence")
    
    source_names = {}
    for source_name in string.gmatch(settings.sources, '([^,]+)') do
        table.insert(source_names, source_name)
    end
    
    current_index = 1
    obs.timer_add(show_next_source, settings.delay)
end

function hide_sequence()
    if sequence_running then
        print("Sequence already running")
        return
    end
    
    sequence_running = true
    print("Starting hide sequence")
    
    reverse_source_names = {}
    for source_name in string.gmatch(settings.reverse_sources, '([^,]+)') do
        table.insert(reverse_source_names, source_name)
    end
    
    current_index = 1
    obs.timer_add(hide_next_source, settings.delay)
end

function get_sceneitem_from_source_name(source_name)
    local scenes = obs.obs_frontend_get_scenes()
    for _, scene in ipairs(scenes) do
        local scene_source = obs.obs_scene_from_source(scene)
        if scene_source then
            local scene_item = obs.obs_scene_find_source_recursive(scene_source, source_name)
            if scene_item then
                obs.source_list_release(scenes)
                return scene_item
            end
            obs.obs_scene_release(scene_source)
        end
    end
    obs.source_list_release(scenes)
    return nil
end

function show_next_source()
    if not sequence_running then
        return
    end
    
    if current_index <= #source_names then
        local source_name = source_names[current_index]
        local scene_item = get_sceneitem_from_source_name(source_name)
        if scene_item then
            obs.obs_sceneitem_set_visible(scene_item, true)
            print("Set visibility to true for source: " .. source_name)
        else
            print("Scene item not found for source: " .. source_name)
        end
        
        current_index = current_index + 1
    else
        print("All sources have been shown, stopping sequence")
        sequence_running = false
        obs.timer_remove(show_next_source)
    end
end

function hide_next_source()
    if not sequence_running then
        return
    end
    
    if current_index <= #reverse_source_names then
        local source_name = reverse_source_names[current_index]
        local scene_item = get_sceneitem_from_source_name(source_name)
        if scene_item then
            obs.obs_sceneitem_set_visible(scene_item, false)
            print("Set visibility to false for source: " .. source_name)
        else
            print("Scene item not found for source: " .. source_name)
        end
        
        current_index = current_index + 1
    else
        print("All sources have been hidden, stopping sequence")
        sequence_running = false
        obs.timer_remove(hide_next_source)
    end
end

function script_load(set)
    show_hotkey_id = obs.obs_hotkey_register_frontend("show_sequence", "Show Sequence", show_sequence)
    hide_hotkey_id = obs.obs_hotkey_register_frontend("hide_sequence", "Hide Sequence", hide_sequence)
    local hotkey_save_array = obs.obs_data_get_array(set, "show_sequence")
    obs.obs_hotkey_load(show_hotkey_id, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
    hotkey_save_array = obs.obs_data_get_array(set, "hide_sequence")
    obs.obs_hotkey_load(hide_hotkey_id, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
    print("Script loaded")
end

function script_unload()
    obs.obs_hotkey_unregister(show_hotkey_id)
    obs.obs_hotkey_unregister(hide_hotkey_id)
    print("Script unloaded")
end

function script_save(set)
    local hotkey_save_array = obs.obs_hotkey_save(show_hotkey_id)
    obs.obs_data_set_array(set, "show_sequence", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
    hotkey_save_array = obs.obs_hotkey_save(hide_hotkey_id)
    obs.obs_data_set_array(set, "hide_sequence", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
end
