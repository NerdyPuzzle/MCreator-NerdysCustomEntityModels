{
    ResourceLocation texture = ${input$texture};
    ModelPart part = armRenderEvent.getArm() == HumanoidArm.LEFT ? ((PlayerModel) entityModel).leftArm : ((PlayerModel) entityModel).rightArm;
    boolean partVisible = part.skipDraw;
    part.resetPose();
    part.skipDraw = false;
    part.render(poseStack, armRenderEvent.getMultiBufferSource().getBuffer(RenderType.${generator.map(field$rendertype, "rendertypes")})), armRenderEvent.getPackedLight(), OverlayTexture.NO_OVERLAY);
    part.skipDraw = partVisible;
}