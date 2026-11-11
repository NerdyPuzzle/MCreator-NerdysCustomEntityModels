package ${package}.init;

<#include "procedures.java.ftl">

@EventBusSubscriber(Dist.CLIENT)
public class ${JavaModName}AnimatedModels {
	<#list animatedmodels as model>
		public static EntityModel ${model.getModElement().getRegistryNameUpper()};
	</#list>

	@SubscribeEvent
	public static void initModels(EntityRenderersEvent.AddLayers event) {
		<#list animatedmodels as model>
		${model.getModElement().getRegistryNameUpper()} = create${model.modelName}();
		</#list>
	}

	<#list animatedmodels as model>
	private static EntityModel create${model.modelName}() {
		ModelPart root = Minecraft.getInstance().getEntityModels().bakeLayer(${model.modelName}.LAYER_LOCATION);
		class Animatable${model.modelName} extends ${model.modelName} implements Animatable {
			Animatable${model.modelName}(ModelPart root) { super(root); }

			<#list model.animations as animation>
			   private final KeyframeAnimation keyframeAnimation${animation?index} = safeBake(${animation.animation});
			</#list>

			private final Map<Entity, Map<Integer, Long>> animationStartTimes = new WeakHashMap<>();

			private KeyframeAnimation safeBake(AnimationDefinition source) {
			   try {
				  return source.bake(root);
			   } catch (IllegalArgumentException e) {
				  return new AnimationDefinition(0, false, Map.of()).bake(root);
			   }
			}

			@Override
			public void setupAnim(LivingEntityRenderState state) {
				this.root().getAllParts().forEach(ModelPart::resetPose);
				Entity entity = state.getRenderData(${JavaModName}RenderStateModifiers.LIVING_ENTITY);
				long time = (long) (state.ageInTicks * 50.0F);

				Map<Integer, Long> entityStartTimes = animationStartTimes.computeIfAbsent(entity, e -> new HashMap<>());

				<#list model.animations as animation>
				<#if !animation.walking>
				<#if hasProcedure(animation.condition)>
				if (<@procedureCode animation.condition, {
				   "x": "entity.getX()",
				   "y": "entity.getY()",
				   "z": "entity.getZ()",
				   "entity": "entity",
				   "world": "entity.level()"
				}, false/>) {
					long startTime${animation?index} = entityStartTimes.computeIfAbsent(${animation?index}, k -> time);
					this.keyframeAnimation${animation?index}.apply(time - startTime${animation?index}, ${animation.speed}f);
				} else {
					entityStartTimes.remove(${animation?index});
				}
				<#else>
				long startTime${animation?index} = entityStartTimes.computeIfAbsent(${animation?index}, k -> time);
				this.keyframeAnimation${animation?index}.apply(time - startTime${animation?index}, ${animation.speed}f);
				</#if>
				<#else>
				<#if hasProcedure(animation.condition)>
				if (<@procedureCode animation.condition, {
				   "x": "entity.getX()",
				   "y": "entity.getY()",
				   "z": "entity.getZ()",
				   "entity": "entity",
				   "world": "entity.level()"
				}, false/>) {
					this.keyframeAnimation${animation?index}.applyWalk(state.walkAnimationPos, state.walkAnimationSpeed, ${animation.speed}f, ${animation.amplitude}f);
				}
				<#else>
				this.keyframeAnimation${animation?index}.applyWalk(state.walkAnimationPos, state.walkAnimationSpeed, ${animation.speed}f, ${animation.amplitude}f);
				</#if>
				</#if>
				</#list>
				super.setupAnim(state);
			}

			@Override
			public ModelPart getRoot() {
				return root;
			}
		}
		return new Animatable${model.modelName}(root);
	}
	</#list>

	public static interface Animatable {
		ModelPart getRoot();

		default void applyPlayerRotations(PlayerModel playerModel) {
			ModelPart root = getRoot();

			Map<String, ModelPart> playerParts = Map.of(
				"head",      playerModel.head,
				"body",      playerModel.body,
				"right_arm", playerModel.rightArm,
				"left_arm",  playerModel.leftArm,
				"right_leg", playerModel.rightLeg,
				"left_leg",  playerModel.leftLeg
			);

			playerParts.forEach((name, playerPart) -> {
				try {
					ModelPart myPart = root.getChild(name);
					myPart.loadPose(playerPart.storePose());
				} catch (NoSuchElementException ignored) {
					// this model simply doesn't have a part by that name
				}
			});
		}
	}
}