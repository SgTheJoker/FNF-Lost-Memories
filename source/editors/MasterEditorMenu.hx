package editors;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class MasterEditorMenu extends MusicBeatState
{
	var options:Array<String> = [
		'Week Editor',
		'Menu Character Editor',
		'Dialogue Editor',
		'Dialogue Portrait Editor',
		'Character Editor',
		'Chart Editor'
	];
	private var grpTexts:FlxTypedGroup<Alphabet>;
	private var directories:Array<String> = [null];

	private var curSelected = 0;
	private var curDirectory = 0;
	private var directoryTxt:FlxText;

	override function create()
	{
		FlxG.camera.bgColor = FlxColor.BLACK;
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Editors Main Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.set();
		bg.color = 0xFF353535;
		add(bg);

		grpTexts = new FlxTypedGroup<Alphabet>();
		add(grpTexts);

		for (i in 0...options.length)
		{
			var leText:Alphabet = new Alphabet(0, (70 * i) + 30, options[i], true, false);
			leText.isMenuItem = true;
			leText.targetY = i;
			grpTexts.add(leText);
		}
		
		#if MODS_ALLOWED
		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 42).makeGraphic(FlxG.width, 42, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		directoryTxt = new FlxText(textBG.x, textBG.y + 4, FlxG.width, '', 32);
		directoryTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		directoryTxt.scrollFactor.set();
		add(directoryTxt);
		
		for (folder in Paths.getModDirectories())
		{
			directories.push(folder);
		}

		var found:Int = directories.indexOf(Paths.currentModDirectory);
		if(found > -1) curDirectory = found;
		changeDirectory();
		#end
		changeSelection();

		FlxG.mouse.visible = false;
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}
		#if MODS_ALLOWED
		if(controls.UI_LEFT_P)
		{
			changeDirectory(-1);
		}
		if(controls.UI_RIGHT_P)
		{
			changeDirectory(1);
		}
		#end

		if (controls.BACK)
		{
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			switch(options[curSelected]) {
				case 'Character Editor':
					LoadingState.loadAndSwitchState(new CharacterEditorState(Character.DEFAULT_CHARACTER, false));
				case 'Week Editor':
					MusicBeatState.switchState(new WeekEditorState());
				case 'Menu Character Editor':
					MusicBeatState.switchState(new MenuCharacterEditorState());
				case 'Dialogue Portrait Editor':
					LoadingState.loadAndSwitchState(new DialogueCharacterEditorState(), false);
				case 'Dialogue Editor':
					LoadingState.loadAndSwitchState(new DialogueEditorState(), false);
				case 'Chart Editor'://felt it would be cool maybe
					LoadingState.loadAndSwitchState(new ChartingState(), false);
			}
			FlxG.sound.music.volume = 0;
			#if PRELOAD_ALL
			FreeplayState.destroyFreeplayVocals();
			#end
		}
		
		var bullShit:Int = 0;
		for (item in grpTexts.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;
	}

	#if MODS_ALLOWED
	function changeDirectory(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curDirectory += change;

		if(curDirectory < 0)
			curDirectory = directories.length - 1;
		if(curDirectory >= directories.length)
			curDirectory = 0;
	
		WeekData.setDirectoryFromWeek();
		if(directories[curDirectory] == null || directories[curDirectory].length < 1)
			directoryTxt.text = '< No Mod Directory Loaded >';
		else
		{
			Paths.currentModDirectory = directories[curDirectory];
			directoryTxt.text = '< Loaded Mod Directory: ' + Paths.currentModDirectory + ' >';
		}
		directoryTxt.text = directoryTxt.text.toUpperCase();
	}
	#end
}
//hola se que es raro que oculte cosas aca
//pero antes que les de la ultima pieza, le voy a contar la historia de este mod
//yo conoci a Fz_Green (o green para los panas) por alla a incios del 2022 en un grupos de amigos del liceo
//cuando vi que estaba haciendo un mod le pregunte si podia ayudarle con su mod, le mostre una cosa que hice y me dijo que si
//despues de eso, empezamos a trabajar como locos, haciendo conceptos, ideas y programando
//tambien el me hizo conocer personas, como a masker, Y a voiid, asi que le agradesco a el por haberme presentado a ustedes y a la comunidad
//despues de que se nos uniera masker seguimos trabando, y despues ya teniamos 2 canciones hechas, pero no charteadas
//mientras pasaban los dias y meses no sabiamos que hacer la verdad, teniamos un menu con cancion, 2 canciones sin chartear y
//una extra que seria un cover
//despues, paso lo inesperado, un dia, mi disco duro secundario simplemente murio, alli tenia los ultimos cambios
//asi que tuve que re-hacerlos con los cambios que tenia en el github que me ayudo un poco
//despues siguieron los meses, cuando green y masker empezaron a hacer sus mods corrupted (el de pibby y el de amongus)
//fue cuando el proyecto murio, despues de unos meses (si green vee esto corrigeme porfa), me dijo que quitara el video de lost memories de mi canal
//el me dijo que ya estaba cancelado el mod, y que lo iban a re-hacer (osea, el mod de pibby) asi que lo puse en privado
//el mod se quedo aqui en github en privado y en mi computadora hasta el dia que escribo esto
//la verdad quisiera que este mod se hubiera terminando, hubiera sido mi primer trabajo en un mod completo (aun que ese titulo al final se lo quedo voiid sides)
//Le agradezco nuevamente a green por haberme presentado a voiid ya que o si no no estaria aqui hoy
//la verdad no puedo imaginar que hubiera sido si no hubiera conocido a green
// Se despide, [SG] The Joker
//
//ya saben que hacer
// QK30IKZ
