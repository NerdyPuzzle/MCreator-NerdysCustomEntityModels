{
    Entity renderEntity${cbi} = ${input$entity};
    if (Minecraft.getInstance().getEntityRenderDispatcher().getRenderer(renderEntity${cbi}) instanceof LivingEntityRenderer renderer${cbi}) {
        Identifier texture = ${input$texture};
        renderEntity(entityRenderEvent, renderer${cbi}.getModel(), RenderTypes.${generator.map(field$rendertype, "rendertypes")}), ${JavaModName}RenderStateModifiers.cloneRenderState((LivingEntityRenderState) renderer${cbi}.createRenderState(), entityRenderEvent.getRenderState()));
    }
}