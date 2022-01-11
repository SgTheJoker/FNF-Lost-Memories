function onCreate()
	-- background shit
	makeLuaSprite('cielo', 'cielo', -600, -31.95);
	setScrollFactor('cielo', 0.9, 0.9);
	
	makeLuaSprite('suelo', 'suelo', 4.5, 8);
	setScrollFactor('suelo', 0.9, 0.9);
	scaleObject('suelo', 1.1, 1.1);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end