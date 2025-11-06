<#include "procedures.java.ftl">
@EventBusSubscriber(Dist.CLIENT) public class ${name}Procedure {
	@SubscribeEvent public static void onPlayerRendered(RenderPlayerEvent.Pre event) {
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
				"playerRenderEvent": "event",
				"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}

	public static Collection<Runnable> capes = new ConcurrentLinkedQueue<>();

	public static void offsetScale(PlayerModel model, Vector3f offset) {
		model.head.offsetScale(offset);
		model.head.y += offset.x() > 0 ? 0.05 : -0.05;
		model.body.offsetScale(offset);
		model.leftArm.offsetScale(offset);
		model.rightArm.offsetScale(offset);
		model.leftLeg.offsetScale(offset);
		model.rightLeg.offsetScale(offset);
		model.hat.offsetScale(offset);
		model.hat.y += offset.x() > 0 ? 0.05 : -0.05;
		model.jacket.offsetScale(offset);
		model.leftSleeve.offsetScale(offset);
		model.rightSleeve.offsetScale(offset);
		model.leftPants.offsetScale(offset);
		model.rightPants.offsetScale(offset);
	}

	public static void renderHumanoid(RenderPlayerEvent playerRenderEvent, PlayerModel model, VertexConsumer vertexConsumer, PlayerRenderState state) {
		PoseStack poseStack = playerRenderEvent.getPoseStack();
		poseStack.pushPose();
        CompoundTag playerData = state.getRenderData(${JavaModName}RenderStateModifiers.LIVING_ENTITY).getPersistentData();
        float oldAnimationProgress = 0;
        float oldAgeInTicks = 0;
        if (playerData.contains("PlayerAnimationProgress")) {
            oldAnimationProgress = playerData.getFloatOr("PlayerAnimationProgress", 0);
            oldAgeInTicks = playerData.getFloatOr("LastTickTime", 0);
        }
		model.setupAnim(state);
        if (playerData.contains("PlayerAnimationProgress") && playerData.getFloatOr("PlayerAnimationProgress", 0) > 0) {
            playerData.putFloat("PlayerAnimationProgress", oldAnimationProgress);
            playerData.putFloat("LastTickTime", oldAgeInTicks);
        } else if (oldAnimationProgress > 0) {
            model.setupAnim(state);
        }
		playerRenderEvent.getRenderer().setupRotations(state, poseStack, state.bodyRot, 0);
		poseStack.scale(-0.938f, -0.938f, 0.938f);
		poseStack.translate(0.0D, -1.501, 0.0D);
		Vector3f offset = new Vector3f(0.015f);
	    offsetScale(model, offset);
		if (!capes.isEmpty()) {
		    capes.forEach(cape -> cape.run());
		    capes.clear();
		}
		model.renderToBuffer(poseStack, vertexConsumer, playerRenderEvent.getPackedLight(), OverlayTexture.NO_OVERLAY);
		offset.negate();
		offsetScale(model, offset);
		poseStack.popPose();
	}