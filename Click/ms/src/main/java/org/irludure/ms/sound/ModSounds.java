/*    */ package org.irludure.ms.sound;
/*    */ 
/*    */

import net.minecraft.resources.ResourceLocation;
import net.minecraft.sounds.SoundEvent;
import net.minecraftforge.eventbus.api.IEventBus;
import net.minecraftforge.registries.DeferredRegister;
import net.minecraftforge.registries.ForgeRegistries;
import net.minecraftforge.registries.RegistryObject;
import org.irludure.ms.ModifiedSurvival;
import org.irludure.ms.util.ItemDropUtil;

import java.util.HashMap;
import java.util.Random;
import java.util.Vector;

/*    */
/*    */ 
/*    */ 
/*    */ public class ModSounds
/*    */ {
    /* 14 */   public static final DeferredRegister<SoundEvent> SOUND_EVENTS = DeferredRegister.create(ForgeRegistries.SOUND_EVENTS, "ms");
    /*    */
    /* 17 */   public static final RegistryObject<SoundEvent> alternate = registerSoundEvent("alternate");
    /* 18 */   public static final RegistryObject<SoundEvent> ancientwell = registerSoundEvent("ancientwell");
    /* 19 */   public static final RegistryObject<SoundEvent> channeledanger = registerSoundEvent("channeledanger");
    /* 20 */   public static final RegistryObject<SoundEvent> dustycavern = registerSoundEvent("dustycavern");
    /* 21 */   public static final RegistryObject<SoundEvent> fallingfeathers = registerSoundEvent("fallingfeathers");
    /* 22 */   public static final RegistryObject<SoundEvent> firedome = registerSoundEvent("firedome");
    /* 23 */   public static final RegistryObject<SoundEvent> frozenriver = registerSoundEvent("frozenriver");
    /* 24 */   public static final RegistryObject<SoundEvent> gardenhangout = registerSoundEvent("gardenhangout");
    /* 25 */   public static final RegistryObject<SoundEvent> impendingdoom = registerSoundEvent("impendingdoom");
    /* 26 */   public static final RegistryObject<SoundEvent> leafyplanting = registerSoundEvent("leafyplanting");
    /* 27 */   public static final RegistryObject<SoundEvent> messagefromhell = registerSoundEvent("messagefromhell");
    /* 28 */   public static final RegistryObject<SoundEvent> peacefultrack = registerSoundEvent("peacefultrack");
    /* 29 */   public static final RegistryObject<SoundEvent> quickarcade = registerSoundEvent("quickarcade");
    /* 30 */   public static final RegistryObject<SoundEvent> savetheworld = registerSoundEvent("savetheworld");
    /* 31 */   public static final RegistryObject<SoundEvent> toweringheights = registerSoundEvent("toweringheights");
    /* 32 */   public static final RegistryObject<SoundEvent> gangnamstyle = registerSoundEvent("gangnamstyle");
    public static final RegistryObject<SoundEvent> coolwhip_eleven = registerSoundEvent("coolwhip_eleven");
    public static final RegistryObject<SoundEvent> bro_get_on_modified = registerSoundEvent("get_on_modified");
    public static final RegistryObject<SoundEvent> monkey_ambient = registerSoundEvent("monkey_ambient");


    /* 33 */   public static final RegistryObject<SoundEvent> teleport = registerSoundEvent("teleport");
    public static final RegistryObject<SoundEvent> elephant_ambient = registerSoundEvent("elephant_ambient");
    public static final RegistryObject<SoundEvent> blood_night = registerSoundEvent("blood_night");

    private static class SoundMap {
        public static HashMap<String, RegistryObject<SoundEvent>> sections = new HashMap<>();
        public static String mapParent;
        public static RegistryObject<SoundEvent> reg(String sound) {
//            System.out.println(sections);
            if (sound != null) {
                RegistryObject<SoundEvent> registered = registerSoundEvent(mapParent + "." + sound);
                sections.put(sound, registered);
                return registered;
            }
            return null;
        }
        public static void reg(String inSection, int iters) {
            for (int i = 0; i < iters; i++) {
                reg(inSection);
            }
        }

        public static SoundEvent get(String sound) {
            return sections.get(sound).get();
        }

        public static SoundEvent getRandom(String section) {
            return get(section);
        }
    }
    private static class MultiSoundMap {
        public static HashMap<String, Vector<RegistryObject<SoundEvent>>> sections = new HashMap<>();
        public static String mapParent;
        public static void addSection(String sectionName) {
            sections.put(sectionName, new Vector<>());
        }
        public static RegistryObject<SoundEvent> reg(String inSection) {
//            System.out.println(sections);
            Vector<RegistryObject<SoundEvent>> s = sections.get(inSection);
            if (s != null) {
                RegistryObject<SoundEvent> registered = registerSoundEvent(mapParent + "." + inSection + (s.size() + 1));
                s.add(registered);
                return registered;
            }
            return null;
        }
        public static void reg(String inSection, int iters) {
            for (int i = 0; i < iters; i++) {
                reg(inSection);
            }
        }

        public static SoundEvent get(String section, int index) {
//            System.out.println(section);
//            System.out.println(sections);
            return sections.get(section).get(index).get();
        }

        public static SoundEvent getRandom(String section) {
//            System.out.println(sections);
//            System.out.println(section);
            Vector<RegistryObject<SoundEvent>> s = sections.get(section);
            return get(section, ItemDropUtil.random(0, s.size()-1));
        }
    }

    public static class cavewalker extends SoundMap {
        public static void init() {
//            System.out.println("Cavewalker Static Initializer called");
            mapParent = "cavewalker";
            reg("ambient");
            reg("attack");
            reg("hurt");
            reg("roar");
        }
    }

    ///*    */
    /*    */
    private static RegistryObject<SoundEvent> registerSoundEvent(String name) {
        return SOUND_EVENTS.register(name, () -> SoundEvent.createVariableRangeEvent(new ResourceLocation(ModifiedSurvival.MODID, name)));
    }

    /*    */
    /*    */
    public static void register(IEventBus eventBus) {
        /* 41 */
        SOUND_EVENTS.register(eventBus);
        /*    */
    }
}
///*    */ }


/* Location:              C:\Users\theja\Downloads\ms-2.0.jar!\net\jack\ms\sound\ModSounds.class
 * Java compiler version: 17 (61.0)
 * JD-Core Version:       1.1.3
 */