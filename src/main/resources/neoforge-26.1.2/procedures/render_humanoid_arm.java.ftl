{
    Identifier texture = ${input$texture};
    PlayerModel humanoidModel = ${generator.map(field$model, "humanoidmodels")?replace("CUSTOM:", "")};
    PlayerModel playerOriginal = (PlayerModel) entityModel;
    boolean lefthanded = armRenderEvent.getArm() == HumanoidArm.LEFT;
    ModelPart part = lefthanded ? humanoidModel.leftArm : humanoidModel.rightArm;
    boolean partVisible = part.skipDraw;
    part.resetPose();
    if (lefthanded) playerOriginal.leftArm.resetPose(); else playerOriginal.rightArm.resetPose();
    part.loadPose(lefthanded ? playerOriginal.leftArm.storePose() : playerOriginal.rightArm.storePose());
    part.skipDraw = false;
	part.zRot = 0.1f;
    part.xRot = -0.005f;
    part.y = 2;
    part.render(poseStack, Minecraft.getInstance().renderBuffers().bufferSource().getBuffer(RenderTypes.${generator.map(field$rendertype, "rendertypes")})), armRenderEvent.getPackedLight(), OverlayTexture.NO_OVERLAY);
    part.skipDraw = partVisible;
}