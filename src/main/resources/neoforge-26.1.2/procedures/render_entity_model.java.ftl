{
    Identifier texture = ${input$texture};
    renderEntity(entityRenderEvent, ${input$model}, RenderTypes.${generator.map(field$rendertype, "rendertypes")}), entityRenderEvent.getRenderState());
}