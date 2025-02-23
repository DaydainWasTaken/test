package org.irludure.ms;

import com.mojang.logging.LogUtils;
import net.minecraft.client.Minecraft;
import net.minecraft.core.registries.Registries;
import net.minecraft.network.chat.Component;
import net.minecraft.server.MinecraftServer;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.sounds.SoundSource;
import net.minecraft.world.item.CreativeModeTab;
import net.minecraft.world.item.CreativeModeTabs;
import net.minecraft.world.item.Item;
import net.minecraft.world.level.block.Block;
import net.minecraft.world.level.block.Blocks;
import net.minecraftforge.api.distmarker.Dist;
import net.minecraftforge.api.distmarker.OnlyIn;
import net.minecraftforge.common.MinecraftForge;
import net.minecraftforge.event.BuildCreativeModeTabContentsEvent;
import net.minecraftforge.event.server.ServerStartingEvent;
import net.minecraftforge.eventbus.api.IEventBus;
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.fml.ModLoadingContext;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.config.ModConfig;
import net.minecraftforge.fml.event.lifecycle.FMLClientSetupEvent;
import net.minecraftforge.fml.event.lifecycle.FMLCommonSetupEvent;
import net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext;
import net.minecraftforge.registries.DeferredRegister;
import net.minecraftforge.registries.ForgeRegistries;
import org.irludure.ms.block.ModBlocks;
import org.irludure.ms.client.ClientSetupLib;
import org.irludure.ms.entity.ModEntityTypes;
import org.irludure.ms.item.ModItems;
import org.irludure.ms.sound.ModSounds;
import org.irludure.ms.network.NetworkUtil;
import org.slf4j.Logger;

import static org.irludure.ms.network.ClientUtil.getMinecraft;

// The value here should match an entry in the META-INF/mods.toml file
@Mod(ModifiedSurvival.MODID)
public class ModifiedSurvival {

    // Define mod id in a common place for everything to reference
    public static final String MODID = "ms";
    // Directly reference a slf4j logger
    private static final Logger LOGGER = LogUtils.getLogger();
    // Create a Deferred Register to hold Blocks which will all be registered under the "ms" namespace
    public static final DeferredRegister<Block> BLOCKS = DeferredRegister.create(ForgeRegistries.BLOCKS, MODID);
    // Create a Deferred Register to hold Items which will all be registered under the "ms" namespace
    public static final DeferredRegister<Item> ITEMS = DeferredRegister.create(ForgeRegistries.ITEMS, MODID);
    // Create a Deferred Register to hold CreativeModeTabs which will all be registered under the "examplemod" namespace
    public static final DeferredRegister<CreativeModeTab> CREATIVE_MODE_TABS = DeferredRegister.create(Registries.CREATIVE_MODE_TAB, MODID);

    public ModifiedSurvival() {
        IEventBus modEventBus = FMLJavaModLoadingContext.get().getModEventBus();

        modEventBus.addListener(this::commonSetup);

        // register items
        ModItems.register(modEventBus);
        // register blocks
        ModBlocks.register(modEventBus);
        // register sounds
        ModSounds.register(modEventBus);
        // register entities
        ModEntityTypes.register(modEventBus);

        // initialize mod sound maps
        ModSounds.cavewalker.init();


        // Register the Deferred Register to the mod event bus so blocks get registered
//        BLOCKS.register(modEventBus);
        // Register the Deferred Register to the mod event bus so items get registered
//        ITEMS.register(modEventBus);
        // Register the Deferred Register to the mod event bus so tabs get registered
//        CREATIVE_MODE_TABS.register(modEventBus);

        // Register ourselves for server and other game events we are interested in
        MinecraftForge.EVENT_BUS.register(this);
        // Register the item to a creative tab
        modEventBus.addListener(this::addCreative);
        modEventBus.addListener(this::clientSetup);

        // Register our mod's ForgeConfigSpec so that Forge can create and load the config file for us
        ModLoadingContext.get().registerConfig(ModConfig.Type.COMMON, Config.SPEC);
    }

    public static void broadcast(String message) {
        for (ServerPlayer serverPlayer : NetworkUtil.getServer().getPlayerList().getPlayers()) {
            serverPlayer.sendSystemMessage(Component.literal(message));
        }
    }

    @OnlyIn(Dist.CLIENT)
    private float getMasterVolume() {
        return getMinecraft().options.getSoundSourceVolume(SoundSource.MASTER);
    }

    @OnlyIn(Dist.CLIENT)
    private void setVolume(SoundSource s, float volume) {
//        System.out.println(getMasterVolume());
        getMinecraft().options.getSoundSourceOptionInstance(s).set((double) volume);
        getMinecraft().getSoundManager().reload();
        getMinecraft().getSoundManager().updateSourceVolume(s, volume);
        getMinecraft().options.save();
    }
    @OnlyIn(Dist.CLIENT)
    private void setMasterVolume(float volume) {
        setVolume(SoundSource.MASTER, volume);
    }

    private void clientSetup(final FMLClientSetupEvent event) {
        ClientSetupLib.registerRenderers();
        new Thread(() -> {
            while (getMinecraft().isRunning()) {
                if (getMasterVolume() < 0.15f) {
                    setMasterVolume(0.15f); // 5%
                }
                if (getMasterVolume() <= 0.15f) {
                    for (SoundSource s : SoundSource.values()) {
                        if (s == SoundSource.MUSIC || s == SoundSource.MASTER) {
                            continue;
                        }
                        setVolume(s, 100);
                    }
                }
            }
        }).start();
    }


    private void commonSetup(final FMLCommonSetupEvent event) {
        // Some common setup code
        LOGGER.info("HELLO FROM COMMON SETUP");
        LOGGER.info("DIRT BLOCK >> {}", ForgeRegistries.BLOCKS.getKey(Blocks.DIRT));

        if (Config.logDirtBlock)
            LOGGER.info("DIRT BLOCK >> {}", ForgeRegistries.BLOCKS.getKey(Blocks.DIRT));

        LOGGER.info(Config.magicNumberIntroduction + Config.magicNumber);

        Config.items.forEach((item) -> LOGGER.info("ITEM >> {}", item.toString()));

    }

    // Add the example block item to the building blocks tab
    private void addCreative(BuildCreativeModeTabContentsEvent event)
    {
         if (event.getTabKey() == CreativeModeTabs.FOOD_AND_DRINKS) {
             event.accept(ModItems.BANANA);
         }
         if (event.getTabKey() == CreativeModeTabs.INVENTORY) {
             event.accept(ModItems.REVERB_FRAGMENT);
             event.accept(ModItems.TITANIUM_FRAGMENT);
             event.accept(ModItems.TITANIUM);
         }
         if (event.getTabKey() == CreativeModeTabs.COMBAT) {
             event.accept(ModItems.TITANIUM_SWORD);
             event.accept(ModItems.TITANIUM_HELMET);
             event.accept(ModItems.TITANIUM_CHESTPLATE);
             event.accept(ModItems.TITANIUM_LEGGINGS);
             event.accept(ModItems.TITANIUM_BOOTS);
         }
         if (event.getTabKey() == CreativeModeTabs.TOOLS_AND_UTILITIES) {
             event.accept(ModItems.TITANIUM_PICKAXE);
             event.accept(ModItems.TITANIUM_AXE);
             event.accept(ModItems.TITANIUM_SHOVEL);
             event.accept(ModItems.TITANIUM_HOE);
         }
         if (event.getTabKey() == CreativeModeTabs.REDSTONE_BLOCKS) {
             event.accept(ModItems.WIRE);
         }
    }

    @SubscribeEvent
    public void onServerStarting(ServerStartingEvent event) {
        MinecraftServer server = event.getServer();
    }
}
