library db_generator;

import 'package:build/build.dart';
import 'package:db_generator/src/generator/databaseTableGenerator.dart';
import 'package:source_gen/source_gen.dart';

Builder databaseTableBuilder(BuilderOptions options) => SharedPartBuilder([DatabaseTableGenerator()], 'classG');
