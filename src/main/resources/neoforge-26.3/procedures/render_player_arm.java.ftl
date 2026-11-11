{
    Identifier texture = ${input$texture};
    ModelPart part = armRenderEvent.getArm() == HumanoidArm.LEFT ? ((PlayerModel) entityModel).leftArm : ((PlayerModel) entityModel).rightArm;
    boolean partVisible = part.skipDraw;
    part.resetPose();
    part.skipDraw = false;
	part.zRot = 0.1f;
    part.xRot = -0.005f;
    part.y = 2;
    ${JavaModName}RenderStateModifiers.submitModelPart(armRenderEvent.getSubmitNodeCollector(), part, poseStack, RenderTypes.${generator.map(field$rendertype, "rendertypes")}), armRenderEvent.getLightCoords(), OverlayTexture.NO_OVERLAY);
    part.skipDraw = partVisible;
}