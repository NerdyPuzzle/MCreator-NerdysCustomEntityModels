{
    Identifier texture = ${input$texture};
    renderEntity(playerRenderEvent, ${input$model}, RenderTypes.${generator.map(field$rendertype, "rendertypes")}), playerRenderEvent.getRenderState());
}