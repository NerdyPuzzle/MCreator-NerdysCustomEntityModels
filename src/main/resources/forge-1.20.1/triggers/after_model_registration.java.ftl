<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD, value = Dist.CLIENT)
public class ${name}Procedure {
	@SubscribeEvent public static void afterModelRegistration(EntityRenderersEvent.AddLayers event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}