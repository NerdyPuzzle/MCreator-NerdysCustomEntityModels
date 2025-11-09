{
    ResourceLocation texture = ${input$texture};
    renderEntity(entityRenderEvent, ${input$model}, (LivingEntity) entity, entityRenderEvent.getMultiBufferSource().getBuffer(RenderType.${generator.map(field$rendertype, "rendertypes")})));
}