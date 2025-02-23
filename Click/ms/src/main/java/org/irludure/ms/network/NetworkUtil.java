package org.irludure.ms.network;

import net.minecraft.server.MinecraftServer;
import net.minecraftforge.server.ServerLifecycleHooks;

public class NetworkUtil {
    public static MinecraftServer getServer() {
        return ServerLifecycleHooks.getCurrentServer();
    }
}
