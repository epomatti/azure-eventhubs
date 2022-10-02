package io.pomatti.config;

import java.nio.file.*;
import java.util.List;

public class Envs {

  public static void load() throws Exception {
    final Path path = Paths.get(".env");
    final List<String> lines = Files.readAllLines(path);
    lines.forEach(
        (line) -> {
          final String[] split = line.split("=", 2);
          final String name = split[0];
          final String value = split[1];
          System.setProperty(name, value);
        });
  }
}
