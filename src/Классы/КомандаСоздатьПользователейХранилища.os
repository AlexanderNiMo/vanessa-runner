///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Подключение ИБ к хранилищу конфигурации 1С.
//
// TODO добавить фичи для проверки команды
// 
// Служебный модуль с набором методов работы с командами приложения
//
// Структура модуля реализована в соответствии с рекомендациями 
// oscript-app-template (C) EvilBeaver
//
///////////////////////////////////////////////////////////////////////////////////////////////////

#Использовать logos

Перем Лог;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ТекстОписания = 
		"     Подключение ИБ к хранилищу конфигурации 1С.
		|     ";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, 
		ТекстОписания);
	
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "ПутьПодключаемогоХранилища", 
		"Строка подключения к хранилищу
		|	(возможно указание как файлового пути, так и пути через http или tcp)");
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "ЛогинАдминистратора", "Логин администратора хранилища 1С");
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "ПарольАдминистратора", "Пароль администратора хранилища 1С");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-user", "Пользователь хранилища. 
		|	Обязательный параметр");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-pwd", "Пароль.
		|	Обязательный параметр");
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-role", "Назначаемая роль. Возможные варианты:
		|	ReadOnly — право на просмотр,
		|	LockObjects — право на захват объектов,
		|	ManageConfigurationVersions — право на изменение состава версий,
		|	Administration — право на административные функции.
		|
		|Обязательный параметр");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);
	
КонецПроцедуры // ЗарегистрироватьКоманду

// Выполняет логику команды
// 
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Соответствие - дополнительные параметры (необязательно)
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Лог = ДополнительныеПараметры.Лог;

	ЛогинПользователя = ПараметрыКоманды["--storage-user"];
	ПарольПользователя = ПараметрыКоманды["--storage-pwd"];
	РольПользователя = ПараметрыКоманды["--storage-role"];

	Ожидаем.Что(ЛогинПользователя, " не задан логин создаваемого пользователя хранилища").Заполнено();
	Ожидаем.Что(ПарольПользователя, " не задан пароль создаваемого пользователя хранилища").Заполнено();
	Ожидаем.Что(РольПользователя, 
		"Не заполнены роли пользователя. Они должны быть заданы через параметр ком.строки --storage-role").Заполнено();
	
	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];
	СтрокаПодключения = ДанныеПодключения.СтрокаПодключения;
	Если Не ЗначениеЗаполнено(СтрокаПодключения) Тогда
		СтрокаПодключения = "/F";
	КонецЕсли;
	
	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;

	МенеджерКонфигуратора.Инициализация(
		СтрокаПодключения, ДанныеПодключения.Пользователь, ДанныеПодключения.Пароль,
		ПараметрыКоманды["--v8version"], ПараметрыКоманды["--uccode"],
		ДанныеПодключения.КодЯзыка
		);

	Попытка
		МенеджерКонфигуратора.СоздатьПользователяХранилища(
			ПараметрыКоманды["ПутьПодключаемогоХранилища"], ПараметрыКоманды["ЛогинАдминистратора"], 
			ПараметрыКоманды["ПарольАдминистратора"],
			ЛогинПользователя, ПарольПользователя, РольПользователя);
	Исключение
		МенеджерКонфигуратора.Деструктор();
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

	МенеджерКонфигуратора.Деструктор();

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;
КонецФункции // ВыполнитьКоманду
