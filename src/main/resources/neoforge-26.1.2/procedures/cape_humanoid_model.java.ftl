<#assign humanoid = generator.map(field$model, "humanoidmodels")?replace("CUSTOM:", "")>
<#assign part = generator.map(field$modelpart, "humanoidparts")>
{
    capes.add(() -> {
        AvatarRenderState state = (AvatarRenderState) playerRenderEvent.getRenderState();
        ${humanoid}.${part}
            .rotateBy(
                new Quaternionf()
                    .rotateY((float) -Math.PI)
                    .rotateX(-Math.min(((6.0F + state.capeLean / 2.0F + state.capeFlap) * (float) (Math.PI / 180.0)) + ${humanoid}.${part}.xRot, ${opt.toFloat(input$maxRotation)}))
                    .rotateZ(-(state.capeLean2 / 2.0F * (float) (Math.PI / 180.0)))
                    .rotateY((180.0F - state.capeLean2 / 2.0F) * (float) (Math.PI / 180.0))
            );
    });
}