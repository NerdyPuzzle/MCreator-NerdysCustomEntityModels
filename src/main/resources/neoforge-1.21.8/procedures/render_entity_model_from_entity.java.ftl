{
    Entity renderEntity${cbi} = ${input$entity};
    if (Minecraft.getInstance().getEntityRenderDispatcher().getRenderer(renderEntity${cbi}) instanceof LivingEntityRenderer renderer${cbi}) {
        ResourceLocation texture = ${input$texture};
        renderEntity(entityRenderEvent, renderer${cbi}.getModel(), entityRenderEvent.getMultiBufferSource().getBuffer(RenderType.${generator.map(field$rendertype, "rendertypes")})), ${JavaModName}RenderStateModifiers.cloneRenderState((LivingEntityRenderState) renderer${cbi}.createRenderState(), entityRenderEvent.getRenderState()));
    }
}