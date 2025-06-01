shader_type canvas_item;
uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 flash_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Standardmäßig Rot

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = texture(TEXTURE, UV); // Originalfarbe des Pixels

    // Mische die Originalfarbe mit der Blitzfarbe basierend auf flash_amount
    // LERP (Linear Interpolation) mischt zwei Werte
	color.rgb = mix(color.rgb, flash_color.rgb, flash_amount);

    // Setze die alpha Komponente der Farbe
	color.a = texture(TEXTURE, UV).a; // Behalte die ursprüngliche Transparenz

	COLOR = color; // Setze die endgültige Farbe des Pixels
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
