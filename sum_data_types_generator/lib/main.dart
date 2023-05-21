import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import './data_classes.dart';
import './sum_types.dart';

Builder generateSumDataTypes(BuilderOptions options) => SharedPartBuilder(
      [
        SumTypeGenerator(),
        DataClassGenerator(),
      ],
      'sum_data_types',
    );
