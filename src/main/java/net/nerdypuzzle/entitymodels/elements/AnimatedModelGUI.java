package net.nerdypuzzle.entitymodels.elements;

import net.mcreator.ui.MCreator;
import net.mcreator.ui.component.SearchableComboBox;
import net.mcreator.ui.component.util.ComboBoxUtil;
import net.mcreator.ui.component.util.ComponentUtils;
import net.mcreator.ui.component.util.PanelUtils;
import net.mcreator.ui.help.HelpUtils;
import net.mcreator.ui.init.L10N;
import net.mcreator.ui.laf.renderer.ModelComboBoxRenderer;
import net.mcreator.ui.laf.themes.Theme;
import net.mcreator.ui.component.JEmptyBox;
import net.mcreator.ui.minecraft.entityanimations.JEntityAnimationList;
import net.mcreator.ui.minecraft.entityanimations.JEntityAnimationListEntry;
import net.mcreator.ui.procedure.ProcedureSelector;
import net.mcreator.ui.modgui.ModElementGUI;
import net.mcreator.ui.validation.AggregatedValidationResult;
import net.mcreator.workspace.elements.ModElement;
import net.mcreator.workspace.resources.Model;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.swing.*;
import javax.swing.border.TitledBorder;
import java.awt.*;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public class AnimatedModelGUI extends ModElementGUI<AnimatedModel> {
    private final SearchableComboBox<Model> animatedModel = new SearchableComboBox<>();
    private JEntityAnimationList animations;

    public AnimatedModelGUI(MCreator mcreator, @Nonnull ModElement modElement, boolean editingMode) {
        super(mcreator, modElement, editingMode);
        initGUI();
        super.finalizeGUI();
    }

    protected void initGUI() {
        animations = new JEntityAnimationList(mcreator, this, Collections::emptyList) {
            @Override
            protected JEntityAnimationListEntry newEntry(JPanel parent, List<JEntityAnimationListEntry> entryList, boolean userAction) {
                JEntityAnimationListEntry entry = super.newEntry(parent, entryList, userAction);
                moveConditionToTopLine(entry);
                return entry;
            }
        };
        
        animatedModel.setRenderer(new ModelComboBoxRenderer());
        ComponentUtils.deriveFont(animatedModel, 16);
        
        JPanel pane2 = new JPanel(new BorderLayout(10, 10));
        JPanel model = new JPanel(new GridLayout(1, 2, 10, 10));

        model.add(HelpUtils.wrapWithHelpButton(withEntry("curios/java_model"), L10N.label("elementgui.humanoidmodel.java_model")));
        model.add(animatedModel);

        model.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(Theme.current().getForegroundColor(), 1),
                L10N.t("elementgui.humanoidmodel.model"), TitledBorder.LEADING,
                TitledBorder.DEFAULT_POSITION, getFont(), Theme.current().getForegroundColor()));

        JComponent animationsList = PanelUtils.northAndCenterElement(
                HelpUtils.wrapWithHelpButton(this.withEntry("entity/model_animations"),
                        L10N.label("elementgui.living_entity.model_animations")), animations);
        animationsList.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        JPanel renderingPanel = new JPanel(new BorderLayout(10, 10));
        JPanel humanoidParts = new JPanel(new GridLayout(4, 1, 2, 2));
        humanoidParts.add("Center", animationsList);


        renderingPanel.add("Center", PanelUtils.northAndCenterElement(model, humanoidParts));
        pane2.add("Center", PanelUtils.totalCenterInPanel(renderingPanel));

        pane2.setOpaque(false);
        model.setOpaque(false);
        humanoidParts.setOpaque(false);
        renderingPanel.setOpaque(false);

        addPage(pane2).lazyValidate(() -> animatedModel.getSelectedItem() != null
                ? new AggregatedValidationResult.PASS()
                : new AggregatedValidationResult.FAIL(L10N.t("elementgui.humanoidmodel.no_model")));
    }

    public void reloadDataLists() {
        super.reloadDataLists();
        ComboBoxUtil.updateComboBoxContents(animatedModel, Model.getModels(mcreator.getWorkspace()).stream()
                .filter(el -> el.getType() == Model.Type.JAVA)
                .collect(Collectors.toList()));
        animations.reloadDataLists();
    }

    protected void openInEditingMode(AnimatedModel model) {
        Model _animatedModel = model.getAnimatedModel();
        if (_animatedModel != null)
            animatedModel.setSelectedItem(_animatedModel);
        animations.setEntries(model.animations);
    }

    public AnimatedModel getElementFromGUI() {
        AnimatedModel model = new AnimatedModel(modElement);
        model.modelName = animatedModel.getSelectedItem() != null ? (Objects.requireNonNull(animatedModel.getSelectedItem())).getReadableName() : null;
        model.animations = animations.getEntries();
        return model;
    }

    private static void moveConditionToTopLine(JEntityAnimationListEntry entry) {
        ProcedureSelector condition = findComponent(entry, ProcedureSelector.class);
        if (condition == null)
            return;
        Container bottomLine = condition.getParent();
        Container line = bottomLine.getParent();
        if (!(line.getLayout() instanceof BorderLayout layout)
                || !(layout.getLayoutComponent(BorderLayout.NORTH) instanceof Container topLine))
            return;

        int index = topLine.getComponentCount();
        for (int i = 0; i < topLine.getComponentCount(); i++) {
            if (topLine.getComponent(i) instanceof JEmptyBox) {
                topLine.remove(i);
                index = i;
                break;
            }
        }
        topLine.add(condition, index);
        line.remove(bottomLine);
    }

    @Nullable
    private static <T extends Component> T findComponent(Container container, Class<T> type) {
        for (Component component : container.getComponents()) {
            if (type.isInstance(component))
                return type.cast(component);
            if (component instanceof Container child) {
                T found = findComponent(child, type);
                if (found != null)
                    return found;
            }
        }
        return null;
    }

    @Override
    @Nullable
    public URI contextURL() throws URISyntaxException {
        return null;
    }
}