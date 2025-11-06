{
    ResourceLocation texture = ${input$texture};
    PlayerModel humanoidModel = ${generator.map(field$model, "humanoidmodels")?replace("CUSTOM:", "")};
    ModelPart part = armRenderEvent.getArm() == HumanoidArm.LEFT ? humanoidModel.leftArm : humanoidModel.rightArm;
    if (armRenderEvent.getArm() == HumanoidArm.LEFT)
        part.copyFrom(((PlayerModel) entityModel).leftArm);
    else
        part.copyFrom(((PlayerModel) entityModel).rightArm);
    part.render(poseStack, armRenderEvent.getMultiBufferSource().getBuffer(RenderType.${generator.map(field$rendertype, "rendertypes")})), armRenderEvent.getPackedLight(), OverlayTexture.NO_OVERLAY);
}