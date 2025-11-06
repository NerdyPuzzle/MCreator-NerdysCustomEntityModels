package ${package}.init;

import com.google.common.reflect.TypeToken;

@EventBusSubscriber(Dist.CLIENT)
public class ${JavaModName}RenderStateModifiers {
    public static final ContextKey<LivingEntity> LIVING_ENTITY = new ContextKey<>(ResourceLocation.parse("c:living_entity_attachment"));

    @SubscribeEvent
    public static void registerModifiers(RegisterRenderStateModifiersEvent event) {
        event.registerEntityModifier(new TypeToken<LivingEntityRenderer<LivingEntity, LivingEntityRenderState, ?>>(){}, (entity, state) -> state.setRenderData(LIVING_ENTITY, (LivingEntity) entity));
    }
}