// Location where we store the binary's previously selected path
String binPathInfoFile = "path.txt";

String pythonPath = "PYTHON_PATH";
String progFilePath = "PROG.PY_PATH";
String binHexFilePath = "BIN_PATH";
String binHexFileName = "BIN_NAME";
// To be used later by UI, after selecting a port, this will be inserted in upload command
String uploadPortName = "";

void sysinfo() {
  println( "__SYS INFO :");
  println( "System     : " + System.getProperty("os.name") + "  " + System.getProperty("os.version") + "  " + System.getProperty("os.arch") );
  println( "JAVA       : " + System.getProperty("java.home")  + " rev: " +javaVersionName);
  //println( System.getProperty("java.class.path") );
  //println( "\n" + isGL() + "\n" );
  println( "OPENGL     : VENDOR " + PGraphicsOpenGL.OPENGL_VENDOR+" RENDERER " + PGraphicsOpenGL.OPENGL_RENDERER+" VERSION " + PGraphicsOpenGL.OPENGL_VERSION+" GLSL_VERSION: " + PGraphicsOpenGL.GLSL_VERSION);
  println( "user.home  : " + System.getProperty("user.home") );
  println( "user.dir   : " + System.getProperty("user.dir") );
  println( "user.name  : " + System.getProperty("user.name") );
  println( "sketchPath : " + sketchPath() );
  println( "dataPath   : " + dataPath("") );
  println( "dataFile   : " + dataFile("") );
  println( "frameRate  :  actual "+nf(frameRate, 0, 1));
  println( "canvas     : width "+width+" height "+height+" pix "+(width*height));
}

int OS() {
  int osn = 0;

  if (System.getProperty("os.name").equals("Mac OS X")) {
    // TBD accomodate other mac OS name types
    osn = 0;
  } else if (System.getProperty("os.name").equals("Windows")) {
    // TBD accomodate other indows name types
    osn = 1;
  } else if (System.getProperty("os.name").equals("Windows")) {
    osn = 2;
  } else {
    osn = 3;
  }
  return osn;
}

String getPythonPath(int _osn) {
  String pyPath = "";
  if (_osn == 0) {
    // mac OS specific python3
    pyPath = sketchPath() + "/tools/python3/macos/python3";
  } else if (_osn == 1) {
    // windows specific python3
    pyPath = sketchPath() + "\\tools\\python3\\windows\\python3.exe";
  } else if (_osn == 2) {
    // linux specific python3
    pyPath = sketchPath() + "/tools/python3/linux/python3";
  } else {
    // TBD: Run shell command which python3 and grab the result
  }

  return pyPath;
}

String getPythonProgScptPath(int _osn) {
  String pyScptPath = "";
  if (_osn == 0) {
    // mac OS specific python3
    pyScptPath = sketchPath() + "/tools/prog.py";
  } else if (_osn == 1) {
    // windows specific python3
    pyScptPath = sketchPath() + "\\tools\\prog.py";
  } else if (_osn == 2) {
    // linux specific python3
    pyScptPath = sketchPath() + "/tools/prog.py";
  } else {
    // TBD:
  }
  return pyScptPath;
}



String getJustFileName(String filePath) {
  IntList arrayOfSlashIndices = new IntList();
  int idxOfSlash = 0;
  //for mac or linux
  if (OS() == 0 || OS() == 2) {
    idxOfSlash =  filePath.indexOf("/");
    while (idxOfSlash >= 0) {
      //println(idxOfSlash);
      if (idxOfSlash!=0) {
        arrayOfSlashIndices.append(idxOfSlash);
      }
      idxOfSlash=filePath.indexOf("/", idxOfSlash + 1);
    }
  }

  //for windows
  if (OS() == 1) {
    idxOfSlash =  filePath.indexOf("\\");
    while (idxOfSlash >= 0) {
      //println(idxOfSlash);
      if (idxOfSlash!=0) {
        arrayOfSlashIndices.append(idxOfSlash);
      }
      idxOfSlash=filePath.indexOf("\\", idxOfSlash + 1);
    }
  }

  //printArray(arrayOfSlashIndices);
  int lastIdxOfSlash = arrayOfSlashIndices.get(arrayOfSlashIndices.size()-1);
  String filename = filePath.substring(lastIdxOfSlash+1, filePath.length());
  //println(filename);
  return filename;
}

// ------------------------------------- //
// function to strip file name form path //
// ------------------------------------- //
void binaryFileSelected(File selection) {
  if (selection == null) {
    println("\nSELECTION ABORTED");
  } else {
    binHexFilePath = selection.getAbsolutePath();
    binHexFileName = getJustFileName(binHexFilePath);
    println("\nSELECTED BINARY FILE PATH:\t" + binHexFilePath);
    println("\nSELECTED BINARY FILE:\t" + binHexFileName);

    binFileLabel.setText(binHexFileName);

    // Save the file path info in a text file, for next time loading
    String[] strList = {binHexFilePath};
    // Writes the strings to a file, each on a separate line
    String infoFilePath = "";
    if (OS() == 0 || OS() == 2) {
      // mac or  linux
      infoFilePath = "data/" + binPathInfoFile;
    }
    if (OS() == 1) {
      // win
      infoFilePath = "data\\" + binPathInfoFile;
    }
    try {
      saveStrings(infoFilePath, strList);
      println("INFO FILE SAVED WITH BIN PATH INFO\n");
    }
    catch (Exception e) {
      println("FILE COULD NOT BE SAVED BECAUSE:\n");
      println(e);
    }
  }
}


// On first load ...
void loadAndSetBinaryFilePath(String filename) {
  String infoFilePath = "";
  if (OS() == 0 || OS() == 2) {
    // mac or  linux
    infoFilePath = "data/" + filename;
  }
  if (OS() == 1) {
    // win
    infoFilePath = "data\\" + filename;
  }

  try {
    String[] lines = loadStrings(infoFilePath);
    if (lines.length == 0) {
      return ;
    }
    if (lines[0].length() == 0) {
      return ;
    }
    print("FOUND BIN PATH FROM INFO FILE:\n");
    binHexFilePath = lines[0]; // the first line is the path of the binary
    binHexFileName = getJustFileName(binHexFilePath);
    println(binHexFilePath);

    binFileLabel.setText(binHexFileName);
  }
  catch (Exception e) {
    println("NO INFO FILE FOUND!\n");
    printArray(e);
  }
}
