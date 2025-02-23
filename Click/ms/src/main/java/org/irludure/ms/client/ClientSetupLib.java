package org.irludure.ms.client;

import net.minecraft.client.model.geom.ModelLayers;
import net.minecraft.client.renderer.entity.EntityRenderers;
import net.minecraft.client.renderer.entity.MinecartRenderer;
import net.minecraftforge.api.distmarker.Dist;
import net.minecraftforge.api.distmarker.OnlyIn;
import org.irludure.ms.entity.ModEntityTypes;
import org.irludure.ms.entity.client.*;
import org.irludure.ms.entity.custom.CavewalkerEntity;


@OnlyIn(Dist.CLIENT)
public class ClientSetupLib {
    public static void registerRenderers()
    {
        // Entity Renderers
        EntityRenderers.register(ModEntityTypes.MONKEY.get(), MonkeyRenderer::new);
        EntityRenderers.register(ModEntityTypes.VOID_MONKEY.get(), VoidMonkeyRenderer::new);
        EntityRenderers.register(ModEntityTypes.ELEPHANT.get(), ElephantRenderer::new);
        EntityRenderers.register(ModEntityTypes.TIGER.get(), TigerRenderer::new);
        EntityRenderers.register(ModEntityTypes.RACCOON.get(), RaccoonRenderer::new);
        EntityRenderers.register(ModEntityTypes.DEER.get(), DeerRenderer::new);
        EntityRenderers.register(ModEntityTypes.CAVEWALKER.get(), CavewalkerRenderer::new);
        EntityRenderers.register(ModEntityTypes.SHARK.get(), SharkRenderer::new);
        EntityRenderers.register(ModEntityTypes.FAST_MINECART.get(),
                context -> new MinecartRenderer<>(context, ModelLayers.MINECART));
    }
}