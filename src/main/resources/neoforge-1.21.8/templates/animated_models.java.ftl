package ${package}.init;

<#include "procedures.java.ftl">

@EventBusSubscriber(Dist.CLIENT)
public class ${JavaModName}AnimatedModels {
    <#list animatedmodels as model>
        public static EntityModel ${model.getModElement().getRegistryNameUpper()};
    </#list>

    @SubscribeEvent
    public static void initModels(EntityRenderersEvent.AddLayers event) {
        <#list animatedmodels as model>
        ${model.getModElement().getRegistryNameUpper()} = create${model.modelName}();
        </#list>
    }

    <#list animatedmodels as model>
    private static EntityModel create${model.modelName}() {
        ModelPart root = Minecraft.getInstance().getEntityModels().bakeLayer(${model.modelName}.LAYER_LOCATION);
        return new ${model.modelName}(root) {
    		<#list model.animations as animation>
    			private final KeyframeAnimation keyframeAnimation${animation?index} = safeBake(${animation.animation});
    		</#list>

    		<#-- ideally we would not do this, but many users use animations that animate parts
    			 that don't exist in their model and then complain the game is crashing -->
    		private KeyframeAnimation safeBake(AnimationDefinition source) {
    			try {
    				return source.bake(root);
    			} catch (IllegalArgumentException e) {
    				return new AnimationDefinition(0, false, Map.of()).bake(root);
    			}
    		}

            @Override
            public void setupAnim(LivingEntityRenderState state) {
                this.root().getAllParts().forEach(ModelPart::resetPose);
                Entity entity = state.getRenderData(${JavaModName}RenderStateModifiers.LIVING_ENTITY);
                long time = (long) (state.ageInTicks * 50.0F);
                <#list model.animations as animation>
                <#if hasProcedure(animation.condition)>
                if (<@procedureCode animation.condition, {
                   "x": "entity.getX()",
                   "y": "entity.getY()",
                   "z": "entity.getZ()",
                   "entity": "entity",
                   "world": "entity.level()"
                }, false/>)
                </#if>
                <#if !animation.walking>
                this.keyframeAnimation${animation?index}.apply(time, 1.0F);
                <#else>
                this.keyframeAnimation${animation?index}.applyWalk(state.walkAnimationPos, state.walkAnimationSpeed, ${animation.speed}f, ${animation.amplitude}f);
                </#if>
                </#list>
                super.setupAnim(state);
            }
        };
    }
    </#list>
}