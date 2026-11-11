{
    Identifier texture = ${input$texture};
    renderHumanoid(playerRenderEvent, ${generator.map(field$model, "humanoidmodels")?replace("CUSTOM:", "")}, RenderTypes.${generator.map(field$rendertype, "rendertypes")}), (AvatarRenderState) playerRenderEvent.getRenderState());
}