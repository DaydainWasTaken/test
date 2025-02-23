package org.irludure.ms.item;

import net.minecraft.world.item.*;
import net.minecraftforge.eventbus.api.IEventBus;
import net.minecraftforge.registries.DeferredRegister;
import net.minecraftforge.registries.ForgeRegistries;
import net.minecraftforge.registries.RegistryObject;
import org.irludure.ms.sound.ModSounds;

import static org.irludure.ms.ModifiedSurvival.MODID;

public class ModItems {
    public static final DeferredRegister<Item> ITEMS =
            DeferredRegister.create(ForgeRegistries.ITEMS, MODID);

    public static final RegistryObject<Item> PLASTIC = ITEMS.register("plastic",
            () -> new Item(new Item.Properties()));
    public static final RegistryObject<Item> BANANA = ITEMS.register("banana",
            () -> new Item(new Item.Properties().food(ModFoods.BANANA).stacksTo(16)));
//    public static final RegistryObject<Item> HOMEOSTASIS_ACCELERATOR = ITEMS.register("homeostasis_accelerator",
//            () -> new Item(new Item.Properties().tab(CreativeModeTab.TAB_FOOD).food(ModFoods.HOMEOSTASIS_ACCELERATOR).stacksTo(8)));
    public static final RegistryObject<Item> REVERB_FRAGMENT = ITEMS.register("reverb_fragment", () -> new Item(new Item.Properties()));
//
    public static final RegistryObject<Item> TITANIUM_FRAGMENT = ITEMS.register("titanium_fragment", () -> new Item(new Item.Properties()));
//
    public static final RegistryObject<Item> TITANIUM = ITEMS.register("titanium", () -> new Item(new Item.Properties()));
//
    public static final RegistryObject<Item> GANGNAM_STYLE_RECORD = ITEMS.register("gangnam_style_music_disc", () -> new RecordItem(6, ModSounds.gangnamstyle, new Item.Properties().stacksTo(1), 4390));
//
    public static final RegistryObject<Item> COOLWHIP_ELEVEN_RECORD = ITEMS.register("coolwhip_eleven_music_disc", () -> new RecordItem(6, ModSounds.coolwhip_eleven, new Item.Properties().stacksTo(1),466));
//
    public static final RegistryObject<Item> BRO_GET_ON_MODIFIED_RECORD = ITEMS.register("bro_get_on_modified_music_disc", () -> new RecordItem(6, ModSounds.bro_get_on_modified, new Item.Properties().stacksTo(1), 1289));
//
//
//
    public static final RegistryObject<SwordItem> TITANIUM_SWORD = ITEMS.register("titanium_sword", () -> new SwordItem(ModToolTiers.TITANIUM, 5, -2.5F, new Item.Properties()));
//
    public static final RegistryObject<PickaxeItem> TITANIUM_PICKAXE = ITEMS.register("titanium_pickaxe", () -> new PickaxeItem(ModToolTiers.TITANIUM, 2, -2.8F, new Item.Properties()));
//
    public static final RegistryObject<AxeItem> TITANIUM_AXE = ITEMS.register("titanium_axe", () -> new AxeItem(ModToolTiers.TITANIUM, 8.0F, -2.8F, new Item.Properties()));
//
    public static final RegistryObject<ShovelItem> TITANIUM_SHOVEL = ITEMS.register("titanium_shovel", () -> new ShovelItem(ModToolTiers.TITANIUM, 3.0F, -3.0F, new Item.Properties()));
//
    public static final RegistryObject<HoeItem> TITANIUM_HOE = ITEMS.register("titanium_hoe", () -> new HoeItem(ModToolTiers.TITANIUM, 0, 0.0F, new Item.Properties()));
//
    public static final RegistryObject<Item> TITANIUM_HELMET = ITEMS.register("titanium_helmet", () -> new ArmorItem(ModArmorMaterials.TITANIUM, ArmorItem.Type.HELMET, new Item.Properties()));
//
    public static final RegistryObject<Item> TITANIUM_CHESTPLATE = ITEMS.register("titanium_chestplate", () -> new ArmorItem(ModArmorMaterials.TITANIUM, ArmorItem.Type.CHESTPLATE, new Item.Properties()));
//
    public static final RegistryObject<Item> TITANIUM_LEGGINGS = ITEMS.register("titanium_leggings", () -> new ArmorItem(ModArmorMaterials.TITANIUM, ArmorItem.Type.LEGGINGS, new Item.Properties()));

    public static final RegistryObject<Item> TITANIUM_BOOTS = ITEMS.register("titanium_boots", () -> new ArmorItem(ModArmorMaterials.TITANIUM, ArmorItem.Type.BOOTS, new Item.Properties()));
//
//    public static final RegistryObject<Item> INDUSTRIAL_BOAT = ITEMS.register("industrial_boat", () -> new IndustrialBoatItem(new Item.Properties()));
//
    public static final RegistryObject<Item> WIRE = ITEMS.register("wire", () -> new Item(new Item.Properties()));

    public static void register(IEventBus eventBus) {
        ITEMS.register(eventBus);
    }
}
