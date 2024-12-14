import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teste_projeto/main.dart';

void main() {
  testWidgets('Testa navegação e retorno entre telas, adição de contatos',
      (WidgetTester tester) async {
    // Inicializa o widget
    await tester.pumpWidget(MyApp());

    // Verifica se estamos na tela inicial
    expect(find.text('Lista de Contatos'), findsOneWidget);

    // Encontra o botão para ir para a segunda tela e clica nele
    final addButton = find.byIcon(Icons.add);
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);

    // Espera a navegação para a segunda tela
    await tester.pumpAndSettle();
    expect(find.text('Adicionar Contato'), findsOneWidget);

    final nameField = find.byKey(const Key('name_field'));
    final emailField = find.byKey(const Key('email_field'));
    final phoneField = find.byKey(const Key('phone_field'));

    await tester.enterText(nameField, 'Teste Nome');
    await tester.enterText(emailField, 'teste@email.com');
    await tester.enterText(phoneField, '62 999999999');

    await tester.pump();

    final saveButton = find.byKey(const Key('salvar'));
    expect(saveButton, findsOneWidget);
    await tester.tap(saveButton);

    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 2));

    // Encontra o botão "Voltar" e clica nele
    expect(find.text('Teste Nome'), findsOneWidget);

    final infoButton = find.byKey(const Key('infos'));
    expect(infoButton, findsOneWidget);
    await tester.tap(infoButton);

    expect(find.text('Teste Nome'), findsOneWidget);
    expect(find.text('teste@email.com'), findsOneWidget);
    expect(find.text('62 999999999'), findsOneWidget);

    final editButton = find.byIcon(Icons.edit);
    expect(editButton, findsOneWidget);
    await tester.tap(editButton);

    await tester.pumpAndSettle();

    expect(find.text('Teste Nome'), findsOneWidget);
    expect(find.text('teste@email.com'), findsOneWidget);
    expect(find.text('62 999999999'), findsOneWidget);
  });
}
