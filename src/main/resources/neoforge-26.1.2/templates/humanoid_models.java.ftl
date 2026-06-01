package ${package}.init;

@EventBusSubscriber(Dist.CLIENT)
public class ${JavaModName}HumanoidModels {
    <#list humanoidmodels as model>
        public static PlayerModel ${model.getModElement().getRegistryNameUpper()};
    </#list>

    @SubscribeEvent
    public static void initModels(EntityRenderersEvent.AddLayers event) {
        <#list humanoidmodels as model>
            <#assign modelname = model.getModElement().getRegistryName() + '_temp'>
            ${model.modelName} ${modelname} = new ${model.modelName}(Minecraft.getInstance().getEntityModels().bakeLayer(${model.modelName}.LAYER_LOCATION));
            ${model.getModElement().getRegistryNameUpper()} = new PlayerModel(new ModelPart(Collections.emptyList(), Map.of(
                "head", new ModelPart(Collections.emptyList(), Map.of(
                    <#if model.helmetModelPart != "Empty">
                        "head", ${modelname}.${model.helmetModelPart},
                    <#else>
                        "head", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
                    </#if>
                    "hat", new ModelPart(Collections.emptyList(), Collections.emptyMap())
                )),
                <#if model.bodyModelPart != "Empty">
                    "body", getPlayerPart(${modelname}.${model.bodyModelPart}, "jacket"),
                <#else>
                    "body", getPlayerPart(new ModelPart(Collections.emptyList(), Collections.emptyMap()), "jacket"),
                </#if>
                <#if model.armsModelPartL != "Empty">
                    "left_arm", getPlayerPart(${modelname}.${model.armsModelPartL}, "left_sleeve"),
                <#else>
                    "left_arm", getPlayerPart(new ModelPart(Collections.emptyList(), Collections.emptyMap()), "left_sleeve"),
                </#if>
                <#if model.armsModelPartR != "Empty">
                    "right_arm", getPlayerPart(${modelname}.${model.armsModelPartR}, "right_sleeve"),
                <#else>
                    "right_arm", getPlayerPart(new ModelPart(Collections.emptyList(), Collections.emptyMap()), "right_sleeve"),
                </#if>
                <#if model.leggingsModelPartL != "Empty">
                    "left_leg", getPlayerPart(${modelname}.${model.leggingsModelPartL}, "left_pants"),
                <#else>
                    "left_leg", getPlayerPart(new ModelPart(Collections.emptyList(), Collections.emptyMap()), "left_pants"),
                </#if>
                <#if model.leggingsModelPartR != "Empty">
                    "right_leg", getPlayerPart(${modelname}.${model.leggingsModelPartR}, "right_pants")
                <#else>
                    "right_leg", getPlayerPart(new ModelPart(Collections.emptyList(), Collections.emptyMap()), "right_pants")
                </#if>
            )), false);
        </#list>
    }

    private static ModelPart getPlayerPart(ModelPart modelPart, String child) {
        Map<String, ModelPart> oldChildren = modelPart.children;
        Map<String, ModelPart> newChildren = new HashMap<>(oldChildren);
        newChildren.put(child, new ModelPart(Collections.emptyList(), Collections.emptyMap()));
        modelPart.children = Collections.unmodifiableMap(newChildren);
        return modelPart;
    }
}