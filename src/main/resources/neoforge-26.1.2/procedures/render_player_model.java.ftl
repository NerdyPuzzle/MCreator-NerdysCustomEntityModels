{
    Identifier texture = ${input$texture};
    renderHumanoid(playerRenderEvent, (PlayerModel) entityModel, RenderTypes.${generator.map(field$rendertype, "rendertypes")}), (AvatarRenderState) playerRenderEvent.getRenderState());
}