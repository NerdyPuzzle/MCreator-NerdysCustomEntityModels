package ${package}.init;

<#include "procedures.java.ftl">

@EventBusSubscriber(Dist.CLIENT)
public class ${JavaModName}AnimatedModels {
    <#list animatedmodels as model>
        public static EntityModel ${model.getModElement().getRegistryNameUpper()};
    </#list>
    private static final Vector3f ANIMATION_VECTOR_CACHE = new Vector3f();

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
            private final HierarchicalModel<Entity> animator = new HierarchicalModel<Entity>() {
                @Override
                public ModelPart root() {
                    return root;
                }

                @Override
                public void setupAnim(Entity entity, float limbSwing, float limbSwingAmount,
                                      float ageInTicks, float netHeadYaw, float headPitch) {
                    this.root().getAllParts().forEach(ModelPart::resetPose);
                    long time = (long) (ageInTicks * 50.0F);
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
                    KeyframeAnimations.animate(this, ${animation.animation}, time, 1.0F, ANIMATION_VECTOR_CACHE);
                    <#else>
                    this.animateWalk(${animation.animation}, limbSwing, limbSwingAmount, ${animation.speed}f, ${animation.amplitude}f);
                    </#if>
                    </#list>
                }
            };

            @Override
            public void setupAnim(Entity entity, float limbSwing, float limbSwingAmount,
                                  float ageInTicks, float netHeadYaw, float headPitch) {
                animator.setupAnim(entity, limbSwing, limbSwingAmount, ageInTicks, netHeadYaw, headPitch);
                super.setupAnim(entity, limbSwing, limbSwingAmount, ageInTicks, netHeadYaw, headPitch);
            }
        };
    }
    </#list>
}