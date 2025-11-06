<#include "procedures.java.ftl">
@EventBusSubscriber(Dist.CLIENT) public class ${name}Procedure {
	@SubscribeEvent public static void onEntityRendered(RenderLivingEvent.Pre event) {
	    Entity entity = (Entity) event.getRenderState().getRenderData(${JavaModName}RenderStateModifiers.LIVING_ENTITY);
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "entity.getX()",
				"y": "entity.getY()",
				"z": "entity.getZ()",
				"world": "entity.level()",
				"entity": "entity",
				"poseStack": "event.getPoseStack()",
				"entityModel": "(EntityModel) event.getRenderer().getModel()",
				"entityTexture": "event.getRenderer().getTextureLocation(event.getRenderState())",
				"entityRenderEvent": "event",
				"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}

	public static void renderEntity(RenderLivingEvent entityRenderEvent, EntityModel model, VertexConsumer vertexConsumer, LivingEntityRenderState state) {
        PoseStack poseStack = entityRenderEvent.getPoseStack();
        poseStack.pushPose();
        poseStack.mulPose(Axis.YP.rotationDegrees(180.0F - state.bodyRot));
        if (state.deathTime > 0) {
            float f = ((float)state.deathTime + entityRenderEvent.getPartialTick() - 1f) / 20f * 1.6f;
            f = Mth.sqrt(f);
            if (f > 1f) {
                f = 1f;
            }
            poseStack.mulPose(Axis.ZP.rotationDegrees(f * 90f));
        }
		poseStack.scale(-1, -1, 1);
		poseStack.translate(0.0D, -1.501, 0.0D);
        model.setupAnim(state);
        model.renderToBuffer(poseStack, vertexConsumer, entityRenderEvent.getPackedLight(), LivingEntityRenderer.getOverlayCoords(state, 0));
        poseStack.popPose();
    }