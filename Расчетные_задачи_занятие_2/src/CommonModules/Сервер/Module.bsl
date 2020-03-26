Процедура ЗаполнитьТабличнуюЧастьВедущиеВидыРасчета(ВидРасчета, ПВРОбъект) Экспорт

	Если ПВРОбъект.ВедущиеВидыРасчета.Найти(ВидРасчета, "ВидРасчета") = Неопределено Тогда

		НоваяСтрока = ПВРОбъект.ВедущиеВидыРасчета.Добавить();
		НоваяСтрока.ВидРасчета = ВидРасчета;

	Иначе

		Возврат;

	КонецЕсли;

	Для Каждого ТекСтрокаБазовыеВидыРасчета Из ВидРасчета.БазовыеВидыРасчета Цикл

		ЗаполнитьТабличнуюЧастьВедущиеВидыРасчета(
		ТекСтрокаБазовыеВидыРасчета.ВидРасчета, ПВРОбъект);

	КонецЦикла;

	Если ТипЗнч(ВидРасчета) = Тип("ПланВидовРасчетаСсылка.ОсновныеНачисления") Тогда

		Для Каждого ТекСтрокаВытесняющиеВидыРасчета Из ВидРасчета.ВытесняющиеВидыРасчета Цикл

			ЗаполнитьТабличнуюЧастьВедущиеВидыРасчета(
			ТекСтрокаВытесняющиеВидыРасчета.ВидРасчета, ПВРОбъект);

		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

Процедура ПроведениеКадровыхДокументовОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт

	Источник.Движения.Сотрудники.Записывать = Истина;
	Источник.Движения.Записать();
	ЗаполнитьНаборЗаписей_Сотрудники(Источник);

КонецПроцедуры
Процедура ЗаполнитьНаборЗаписей_Сотрудники(Источник)

	Источник.Движения.Сотрудники.Записывать = Истина;

	Движение = Источник.Движения.Сотрудники.Добавить();

	Движение.Период = Источник.ДатаСобытия;
	Движение.ФизическоеЛицо = Источник.ФизическоеЛицо;
	Движение.Подразделение =Источник.Подразделение;
	Движение.Должность = Источник.Должность;
	Если (ТипЗнч(Источник) = Тип("ДокументОбъект.ПриказОбУвольнении")) Тогда
		Движение.Состояние = Перечисления.СостоянияФизическогоЛица.Уволен;
	Иначе
		Движение.Состояние = Перечисления.СостоянияФизическогоЛица.Работает;
		Движение.ГрафикРаботы = Источник.ГрафикРаботы;
	КонецЕсли;
КонецПроцедуры