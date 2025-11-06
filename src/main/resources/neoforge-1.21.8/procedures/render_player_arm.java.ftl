{
    ResourceLocation texture = ${input$texture};
    ModelPart part = armRenderEvent.getArm() == HumanoidArm.LEFT ? ((PlayerModel) entityModel).leftArm : ((PlayerModel) entityModel).rightArm;
    part.render(poseStack, armRenderEvent.getMultiBufferSource().getBuffer(RenderType.${generator.map(field$rendertype, "rendertypes")})), armRenderEvent.getPackedLight(), OverlayTexture.NO_OVERLAY);
}