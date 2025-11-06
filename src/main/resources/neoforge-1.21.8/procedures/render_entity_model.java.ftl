{
    ResourceLocation texture = ${input$texture};
    renderEntity(entityRenderEvent, ${input$model}, entityRenderEvent.getMultiBufferSource().getBuffer(RenderType.${generator.map(field$rendertype, "rendertypes")})), entityRenderEvent.getRenderState());
}