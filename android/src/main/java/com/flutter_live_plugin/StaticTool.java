package com.flutter_live_plugin;

import io.flutter.plugin.common.EventChannel;

public class StaticTool {
    public EventChannel.EventSink eventSink;

    private static StaticTool instance = new StaticTool();
    public static StaticTool getTool() {
        return instance;
    }
}
