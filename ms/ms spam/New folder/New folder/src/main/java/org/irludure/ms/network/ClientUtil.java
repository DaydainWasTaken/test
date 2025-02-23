package org.irludure.ms.network;

import net.minecraft.client.Minecraft;
import net.minecraft.client.multiplayer.ClientLevel;
import net.minecraft.client.player.LocalPlayer;
import net.minecraft.client.resources.sounds.SimpleSoundInstance;
import net.minecraft.client.resources.sounds.SoundInstance;
import net.minecraft.sounds.SoundEvent;
import net.minecraft.sounds.SoundSource;
import net.minecraft.util.RandomSource;
import org.irludure.ms.sound.ModSounds;

import javax.annotation.Nullable;

// CLIENT-ONLY
public class ClientUtil {
    private static Minecraft cachedMCInstance = Minecraft.getInstance();

    @Nullable
    public static SoundInstance newSoundInstance(@Nullable SoundEvent soundEvent) {
        LocalPlayer localPlayer = ClientUtil.getMinecraft().player;
        if (localPlayer == null || soundEvent == null) {
            return null;
        }
        return new SimpleSoundInstance(ModSounds.blood_night.get(), SoundSource.MASTER, 1.0f, 1.0f, RandomSource.create(), localPlayer.blockPosition());
    }

    public static void play(@Nullable SoundInstance soundInstance) {
        if (soundInstance != null) {
            getMinecraft().getSoundManager().play(soundInstance);
        }
    }

    public static void play(@Nullable SoundEvent soundEvent) {
        if (soundEvent != null) {
            play(newSoundInstance(soundEvent));
        }
    }

    public static void stop(@Nullable SoundInstance soundInstance) {
        if (soundInstance != null) {
            getMinecraft().getSoundManager().stop(soundInstance);
        }
    }

    public static void stopAll() {
        getMinecraft().getSoundManager().stop();
    }

    public static boolean isPlaying(@Nullable SoundInstance soundInstance) {
        if (soundInstance == null) {
            return false;
        }
        return getMinecraft().getSoundManager().isActive(soundInstance);
    }

    public static Minecraft getMinecraft(boolean forceNoCache) {
        if (forceNoCache) {
            cachedMCInstance = Minecraft.getInstance();
            return cachedMCInstance;
        } else {
            return cachedMCInstance;
        }
    }

    public static Minecraft getMinecraft() {
        return cachedMCInstance;
    }

    public static float getDayTime(ClientLevel level) {
        return level.getTimeOfDay(level.getDayTime()) * 24000;
    }

}
