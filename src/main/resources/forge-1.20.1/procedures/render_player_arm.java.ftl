{
    ResourceLocation texture = ${input$texture};
    ModelPart part = armRenderEvent.getArm() == HumanoidArm.LEFT ? ((PlayerModel) entityModel).leftArm : ((PlayerModel) entityModel).rightArm;
    boolean partVisible = part.visible;
    part.resetPose();
    part.visible = true;
    part.render(poseStack, armRenderEvent.getMultiBufferSource().getBuffer(RenderType.${generator.map(field$rendertype, "rendertypes")})), armRenderEvent.getPackedLight(), OverlayTexture.NO_OVERLAY, 1, 1, 1, 1);
    part.visible = partVisible;
}