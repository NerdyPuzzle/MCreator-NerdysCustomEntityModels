{
    ResourceLocation texture = ${input$texture};
    ModelPart part = armRenderEvent.getArm() == HumanoidArm.LEFT ? ((PlayerModel) entityModel).leftSleeve : ((PlayerModel) entityModel).rightSleeve;
    boolean partVisible = part.skipDraw;
    part.resetPose();
    part.skipDraw = false;
	part.zRot = 0.1f;
    part.xRot = -0.005f;
    part.y = 2;
    part.render(poseStack, armRenderEvent.getMultiBufferSource().getBuffer(RenderType.${generator.map(field$rendertype, "rendertypes")})), armRenderEvent.getPackedLight(), OverlayTexture.NO_OVERLAY);
    part.skipDraw = partVisible;
}