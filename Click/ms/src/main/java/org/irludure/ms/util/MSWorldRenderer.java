package org.irludure.ms.util;

import com.mojang.blaze3d.systems.RenderSystem;
import net.minecraft.client.Minecraft;
import net.minecraft.client.multiplayer.ClientLevel;
import net.minecraft.client.resources.sounds.SimpleSoundInstance;
import net.minecraft.client.resources.sounds.Sound;
import net.minecraft.client.resources.sounds.SoundInstance;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.server.MinecraftServer;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.sounds.SoundEvent;
import net.minecraft.sounds.SoundEvents;
import net.minecraft.sounds.SoundSource;
import net.minecraft.util.RandomSource;
import net.minecraft.world.level.Level;
import net.minecraftforge.api.distmarker.Dist;
import net.minecraftforge.api.distmarker.OnlyIn;
import net.minecraftforge.event.TickEvent;
import net.minecraftforge.event.entity.living.LivingDropsEvent;
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.fml.LogicalSide;
import net.minecraftforge.fml.common.Mod;
import org.irludure.ms.ModifiedSurvival;
import org.irludure.ms.base.WithDropEvent;
import org.irludure.ms.network.ClientUtil;
import org.irludure.ms.network.NetworkUtil;
import org.irludure.ms.network.PacketHandler;
import org.irludure.ms.network.packet.S2CMoonStatePacket;
import org.irludure.ms.sound.ModSounds;

import static org.irludure.ms.ModifiedSurvival.broadcast;
import static org.irludure.ms.network.ClientUtil.getMinecraft;

@Mod.EventBusSubscriber(modid = ModifiedSurvival.MODID)
public class MSWorldRenderer {
    public enum MoonState {
        MOON("moon"),
        BLOOD_MOON("blood_moon");

        public final ResourceLocation resource;
        MoonState(String state) {
            resource = new ResourceLocation(ModifiedSurvival.MODID, "textures/enviroment/moons/" + state + ".png");
        }

        public static MoonState random() {
            MoonState[] values = MoonState.values();
            return values[ItemDropUtil.random(0, values.length-1)];
        }

    }

    private static MoonState moonState = MoonState.MOON;
    public static MoonState getMoonState() {
        return moonState;
    }
    public static SoundEvent bloodNightPlaying = null;
    public static boolean nightRegistered = false;

    private static final int bloodnightTickDuration = 6000;
    private static int timeSinceBloodnightPlay = Integer.MAX_VALUE;
    private static SoundInstance bloodNightSound = null;


    // CLIENT-ONLY
    @OnlyIn(Dist.CLIENT)
    public static void setMoonState_Client(MoonState targetMoonState) {
        moonState = targetMoonState;
    }

    // SERVER-ONLY
    public static void setMoonState(MoonState targetMoonState) {
        if (moonState != targetMoonState) {
            moonState = targetMoonState;
            PacketHandler.sendToAllClients(
                    new S2CMoonStatePacket(moonState)
            );
        }
    }

    public static void bindMoonTexture(int moonTextureId, MoonState state) {
        ClientLevel level = getMinecraft().level;
        RenderSystem.setShaderTexture(moonTextureId, state.resource);
    }

    public static Long getTotalTicksPassed() {
        MinecraftServer server = NetworkUtil.getServer();
        long ticks = -Long.MAX_VALUE;
        for (Level level : server.getAllLevels()) {
            long toSet = level.getGameTime();
            if (toSet > ticks) {
                ticks = level.getGameTime();
            }
        }
        if (ticks == -Long.MAX_VALUE) {
            return null;
        } else {
            return ticks;
        }
    }

    // SERVER-ONLY
    public static void updateMoonState() {
//        float dayTime = (NetworkUtil.getServer().overworld().getTimeOfDay(NetworkUtil.getServer().overworld().getDayTime()) * 24000) * 2;
//        System.out.println(dayTime);
        if (NetworkUtil.getServer().overworld().isNight()) {
//            System.out.println("it's night");

            if (!nightRegistered) {
//                System.out.println("Registered night");
                nightRegistered = true;
//                System.out.println("[moonstate update debug] Night Registered is true");
//                System.out.println("[moonstate update debug] Night Started");
                int number = ItemDropUtil.random(1,100);
//                System.out.println("[moonstate update debug] Generated number " + number);
                if (number <= 15) {
//                    System.out.println("[moonstate update debug] Blood Night");
//                    System.out.println("Blood night");
                    setMoonState(MoonState.BLOOD_MOON);
//                    System.out.println("[moonstate update debug] Did not set moonstate");
                } else {
//                    System.out.println("[moonstate update debug] Blood Night has not been picked");
                    setMoonState(MoonState.MOON);
//                    System.out.println("[moonstate update debug] Set moonstate");
                }
            }
        } else {
            setMoonState(MoonState.MOON);
            nightRegistered = false;
        }
//        moonState = MoonState.BLOOD_MOON;
    }

    @SubscribeEvent
    public static void tick(TickEvent.ServerTickEvent event) {
//        System.out.println("Tick");
//        System.out.println("Tick");
        if (event.phase == TickEvent.Phase.END && event.side == LogicalSide.SERVER) {

//            System.out.println("Tickf");
//            System.out.println("Updating moon state");
            updateMoonState();
        }
    }

    @SubscribeEvent
    public static void drop(LivingDropsEvent event) {
        System.out.println("Living Drops Event");
        if (event.getEntity() instanceof WithDropEvent e) {
            e.drop(event);
        }
     }

    @SubscribeEvent
    public static void clientTick(TickEvent.ClientTickEvent event) {
//        System.out.println("Client Tick");
        if (event.phase == TickEvent.Phase.END && event.side == LogicalSide.CLIENT) {
            if (moonState == MoonState.BLOOD_MOON) {
                if (!ClientUtil.isPlaying(bloodNightSound)) {
//                    System.out.println("Playing bloodNightSound");
                    bloodNightSound = ClientUtil.newSoundInstance(ModSounds.blood_night.get());
                    ClientUtil.play(bloodNightSound);
                }
            } else {
                timeSinceBloodnightPlay = Integer.MAX_VALUE;
                if (ClientUtil.isPlaying(bloodNightSound)) {
                    ClientUtil.stop(bloodNightSound);
                }
            }
        }
    }



}