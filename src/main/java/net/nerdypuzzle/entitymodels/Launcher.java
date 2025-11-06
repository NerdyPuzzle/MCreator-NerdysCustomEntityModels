package net.nerdypuzzle.entitymodels;

import net.mcreator.element.ModElementType;
import net.mcreator.element.ModElementTypeLoader;
import net.mcreator.plugin.JavaPlugin;
import net.mcreator.plugin.Plugin;
import net.mcreator.plugin.events.PreGeneratorsLoadingEvent;
import net.mcreator.plugin.events.ui.BlocklyPanelRegisterJSObjects;
import net.nerdypuzzle.entitymodels.elements.HumanoidModel;
import net.nerdypuzzle.entitymodels.elements.HumanoidModelGUI;
import net.nerdypuzzle.entitymodels.parts.PluginJavascriptBridge;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Launcher extends JavaPlugin {
    public static ModElementType<?> HUMANOIDMODEL;
	private static final Logger LOG = LogManager.getLogger("Nerdy's custom entity models");
    public static PluginJavascriptBridge pluginJavascriptBridge = null;

	public Launcher(Plugin plugin) {
		super(plugin);

        addListener(PreGeneratorsLoadingEvent.class, event -> HUMANOIDMODEL = ModElementTypeLoader.register(new ModElementType<>("humanoidmodel", (Character) 'H', HumanoidModelGUI::new, HumanoidModel.class)));
        addListener(BlocklyPanelRegisterJSObjects.class, event -> {
            pluginJavascriptBridge = new PluginJavascriptBridge(event.getBlocklyPanel().getMCreator());
            event.getDOMWindow().put("modelbridge", pluginJavascriptBridge);
        });

		LOG.info("Nerdy's custom entity models plugin was loaded");
	}
}