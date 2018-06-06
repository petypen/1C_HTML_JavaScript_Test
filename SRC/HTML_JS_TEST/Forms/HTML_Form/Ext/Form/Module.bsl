﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем МакетHTML,   сПутьКФайлу;
	Перем элементScript, документHTML, сТекстДокументаHTML;
		
	ОО = РеквизитФормыВЗначение("Объект");
	МакетHTML = ОО.ПолучитьМакет("HTML_DOC");
	документHTML = МакетHTML.ПолучитьДокументHTML();
		
	Если НЕ ПодключитьСкриптКHTMLДокументу(документHTML, "script_01") Тогда
		СообщитьПользователю("Ошибка подключения скрипта ""script_01"" к HTML документу.");
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ПодключитьСкриптКHTMLДокументу(документHTML, "script_02") Тогда
		СообщитьПользователю("Ошибка подключения скрипта ""script_02"" к HTML документу.");
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ТекстHTMLДокумента(документHTML, сТекстДокументаHTML) Тогда
		СообщитьПользователю("Ошибка получения текста HTML документа.");
		Отказ = Истина;
	КонецЕсли;	
	
	ЭтотОбъект.HTML_Fild = сТекстДокументаHTML;
	
КонецПроцедуры

#Область Команды_формы

&НаКлиенте
Процедура КомандаСкрытьБлок1(Команда)
	Выполнить_hidden_div("block1");
КонецПроцедуры

&НаКлиенте
Процедура КомандаПоказатьБлок1(Команда)
	Выполнить_display_div("block1");
КонецПроцедуры

&НаКлиенте
Процедура КомандаСкрытьБлок2(Команда)
	Выполнить_hidden_div("block2");
КонецПроцедуры

&НаКлиенте
Процедура КомандаПоказатьБлок2(Команда)
	Выполнить_display_div("block2");
КонецПроцедуры

&НаКлиенте
Процедура Выполнить_display_div(сИДБлока)
	Элементы.HTML_Fild.Документ.parentWindow.display_div(сИДБлока);
КонецПроцедуры

&НаКлиенте
Процедура Выполнить_hidden_div(сИДБлока)
	Элементы.HTML_Fild.Документ.parentWindow.hidden_div(сИДБлока);
КонецПроцедуры

#КонецОбласти

#Область Служебные_методы

&НаСервере
Функция ПодключитьСкриптКHTMLДокументу(документHTML, Знач сИмяМакетаСкрипта)
	Перем ОО, сПутьКФайлу, макетJS, элементScript, элементыScript;
	Перем бВыполненоБезОшибок;
	
	бВыполненоБезОшибок = Ложь;
	ОО = РеквизитФормыВЗначение("Объект");
	
	сПутьКФайлу = ПолучитьИмяВременногоФайла("js");
	макетJS = ОО.ПолучитьМакет(сИмяМакетаСкрипта);
	макетJS.Записать(сПутьКФайлу);
	
	элементыScript = документHTML.ПолучитьЭлементыПоИмени("script");
	Если элементыScript.Количество() = 0 Тогда
		Возврат бВыполненоБезОшибок;
	КонецЕсли;
	
	Для каждого элементScript Из элементыScript Цикл
		Если элементScript.Источник = сИмяМакетаСкрипта Тогда
			элементScript.УстановитьАтрибут("src", ПутьКФайлуКакURL(сПутьКФайлу));
			бВыполненоБезОшибок = Истина;
			Возврат бВыполненоБезОшибок;
		КонецЕсли;
	КонецЦикла;
	
	Возврат бВыполненоБезОшибок;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПутьКФайлуКакURL(сПуть)
	Возврат "file:///"+СокрЛП(СтрЗаменить(сПуть,"\","/"));
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекстHTMLДокумента(Знач документHTML, сТекстДокументаHTML)
	Перем бВыполненоБезОшибок, ЗаписьDOM, ЗаписьHTML;
	
	ЗаписьDOM = Новый ЗаписьDOM();
	ЗаписьHTML = Новый ЗаписьHTML();
	ЗаписьHTML.УстановитьСтроку();
	Попытка
		ЗаписьDOM.Записать(документHTML, ЗаписьHTML);
		сТекстДокументаHTML = ЗаписьHTML.Закрыть();
		бВыполненоБезОшибок = Истина;
	Исключение
		сТекстДокументаHTML = "";
	    бВыполненоБезОшибок = Ложь;
	КонецПопытки;
	
	Возврат бВыполненоБезОшибок;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура СообщитьПользователю(сТекстСообщения)
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = сТекстСообщения;
	Сообщение.Сообщить();
КонецПроцедуры

#КонецОбласти
