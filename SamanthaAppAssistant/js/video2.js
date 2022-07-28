var status;
var volume = 0.5;
var speed = 1;
var videoFile;
var f = "OPAQUE";
var filtros = ["THRESHOLD", "GRAY", "OPAQUE", "INVERT", "POSTERIZE", "DILATE", "BLUR", "ERODE"];
var permiso = false;

function preload() {
  videoFile = createVideo('../assets/dragonball.webm', videoLoad);
}

function videoLoad() {
  status = 1;
  videoFile.pause();
}

function setup() {
  createCanvas(window.innerWidth, window.innerHeight);
  videoFile.hide();

 
}

function draw() {
  background(150);
  image(videoFile, 0, 0, window.innerWidth, window.innerHeight);
  /*if (f == "POSTERIZE" || f == "BLUR") {
    filter(f, 3);
  } else {
    filter(f);

  }
*/
  filter(f);
  var div = document.getElementById("o-palabras-dichas");           // Get the <div> element with id="myDIV"
  var nodelist = div.getElementsByTagName("P").length;  // Get the number of <p> elements inside <div>
  if (nodelist > 6) {
    div.removeChild(div.lastChild);
    console.log("eliminado")
  }

}

function playVideo() {
  try {
    videoFile.play();
    status = 1;
  } catch (error) {
    console.log("Reintentando");
    $(`<p>Habla nuevamente</p>`).insertAfter(".o-title-say");
  }
}

function pauseVideo() {
  try {
    videoFile.pause();
    status = 0;
  } catch (error) {
    console.log("Reintentando");
    $(`<p>Habla nuevamente</p>`).insertAfter(".o-title-say");
  }
}

function volumeUp() {
  try {
    volume += 0.5;
    videoFile.volume(volume);
  } catch (error) {
    console.log("Reintentando");
    $(`<p>Habla nuevamente</p>`).insertAfter(".o-title-say");
  }
}

function volumeDown() {
  try {
    volume -= 0.5;
    videoFile.volume(volume);
  } catch (error) {
    console.log("Reintentando");
    $(`<p>Habla nuevamente</p>`).insertAfter(".o-title-say");
  }
}

function keyTyped() {
  if (key == 'p') {
    pauseVideo();
  } else if (key == 'r') {
    playVideo();
  } else if (key == '+' && status == 1 && volume < 0.9) {
    volumeUp();
  } else if (key == '-' && status == 1 && volume > 0.1) {
    volumeDown();
  }
}


if (annyang ) {
  // Definición de comandos
  var commands = {
    // Saludar
    'hola mi nombre es *param': function (param) {
      console.log('hola ' + param + ' soy Violet');
    },
    // reproducir el video
    'samanta reproducir': function () {
      $(`<p>Reproducir</p>`).insertAfter(".o-title-say");
      playVideo();
    },
    // detener el video
    'samanta detener': function () {
      $(`<p>Detener</p>`).insertAfter(".o-title-say");
      pauseVideo();

    },
    // reproducir el video
    'samanta subir volumen': function () {
      $(`<p>Subir Volumen</p>`).insertAfter(".o-title-say");
      volumeUp();
    },
    // silenciar el video
    'samanta bajar volumen': function () {
      $(`<p>Bajar Volumen</p>`).insertAfter(".o-title-say");
      volumeDown();
    },
    'samanta filtrar': function () {
      f = random(filtros);
      $(`<p>Filtro: ${f}</p>`).insertAfter(".o-title-say");
      console.log(f);
    },
    'samanta *param': function (param) {
      $(`<p>${param}</p>`).insertAfter(".o-title-say");
    }

  }
  // Configuración 
  annyang.setLanguage('es-CO');



  annyang.debug();

  // Adiciona los comandos a annyang
  annyang.addCommands(commands);

  // Inicia la recepción de comandos de voz
 // annyang.start();
  //annyang.addCallback('soundstart',escuchar );

}

function startTalk() {
  console.log("escuchando");

  annyang.start();  
  
}

function pauseTalk() {
  console.log("Silenciado");
 
  annyang.abort();

}