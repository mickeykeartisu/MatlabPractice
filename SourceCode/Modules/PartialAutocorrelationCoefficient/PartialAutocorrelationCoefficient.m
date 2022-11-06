%% class to calculate Partial Autocorrelation Coefficient(PARCOR)
classdef PartialAutocorrelationCoefficient < handle
    %% how to use : Usage
    %   1. generate PartialAutocorrelationCoefficient instance
    %       -> arguments : 
    %           ・ autocorrelation : signal autocorrelation array
    %           ・ order : analysis order (default : 30)
    %   2. if you'd like to check properties, conduct display_properties() method
    %% ---------- properties ---------- %%
    properties(Access = public)
        autocorrelation
        order
        linear_predictive_coefficient
        partial_autocorelation_coefficient
        numerators
        denominators
    end

    %% ---------- methods ---------- %%
    methods
        %% ---------- default constructor ---------- %%
        function object = PartialAutocorrelationCoefficient(autocorrelation, order)
            switch nargin
                case 1
                    object.autocorrelation = autocorrelation;
                    object.order = 30;
                case 2
                    object.autocorrelation = autocorrelation;
                    object.order = order;
                otherwise
                    throw(MException("Constructor:arguments", "arguments is not correct, input 1 or 2 arguments."));
            end
            object.calculate_partial_autocorrelation_coefficient();
        end
        %% ---------- setters ---------- %%
        % autocorrelation setter
        function set.autocorrelation(object, autocorrelation)
            if length(autocorrelation) < 1
                throw(MException("Setter:autocorrelation", "autocorrelation length is smaller than 1."));
            end
            object.autocorrelation = autocorrelation;
        end

        % order setter
        function set.order(object, order)
            if order < 1
                throw(MException("Setter:order", "order is smaller than 1."));
            end
            object.order = order;
        end

        % linear_predictive_coefficient setter
        function set.linear_predictive_coefficient(object, linear_predictive_coefficient)
            if length(linear_predictive_coefficient) < 1
                throw(MException("Setter:linear_predictive_coefficient", "linear_predictive_coefficient length is smaller than 1."));
            end
            object.linear_predictive_coefficient = linear_predictive_coefficient;
        end

        % partial_autocorelation_coefficient setter
        function set.partial_autocorelation_coefficient(object, partial_autocorelation_coefficient)
            if length(partial_autocorelation_coefficient) < 1
                throw(MException("Setter:partial_autocorelation_coefficient", "partial_autocorelation_coefficient length is smaller than 1."));
            end
            object.partial_autocorelation_coefficient = partial_autocorelation_coefficient;
        end

        % numerators setter
        function set.numerators(object, numerators)
            if length(numerators) < 1
                throw(MException("Setter:numerators", "numerators length is smaller than 1."));
            end
            object.numerators = numerators;
        end

        % denominators setter
        function set.denominators(object, denominators)
            if length(denominators) < 1
                throw(MException("Setter:denominators", "denominators length is smaller than 1."));
            end
            object.denominators = denominators;
        end

        %% ---------- getters ---------- %%
        % autocorrelation getter
        function autocorrelation = get.autocorrelation(object)
            autocorrelation = object.autocorrelation;
        end

        % order getter
        function order = get.order(object)
            order = object.order;
        end

        % linear_predictive_coefficient getter
        function linear_predictive_coefficient = get.linear_predictive_coefficient(object)
            linear_predictive_coefficient = object.linear_predictive_coefficient;
        end

        % partial_autocorelation_coefficient getter
        function partial_autocorelation_coefficient = get.partial_autocorelation_coefficient(object)
            partial_autocorelation_coefficient = object.partial_autocorelation_coefficient;
        end

        % numerators getter
        function numerators = get.numerators(object)
            numerators = object.numerators;
        end

        % denominators getter
        function denominators = get.denominators(object)
            denominators = object.denominators;
        end

        %% ---------- usual method ---------- %%
        % method to initialize parameters
        function initialize_parameters(object)
            object.linear_predictive_coefficient = zeros([1, object.order + 1]);
            object.partial_autocorelation_coefficient = zeros(1, object.order + 1);
            object.numerators = zeros([1, object.order + 1]);
            object.denominators = zeros([1, object.order + 1]);

            object.linear_predictive_coefficient(1, 1) = 1;
            object.linear_predictive_coefficient(1, 2) = 0;
            object.numerators(1, 1) = object.autocorrelation(2, 1);
            object.denominators(1, 1) = object.autocorrelation(1, 1);
        end

        % method to calculate partial autocorrelation coefficient
        function calculate_partial_autocorrelation_coefficient(object)
            object.initialize_parameters();
            for dimension_index = 1 : object.order
                object.partial_autocorelation_coefficient(1, dimension_index + 1) = object.numerators(1, dimension_index) / object.denominators(1, dimension_index);
                object.denominators(1, dimension_index + 1) = object.denominators(1, dimension_index) * (1 - (object.partial_autocorelation_coefficient(1, dimension_index + 1) ^ 2));
                old_linear_predictive_coefficient = object.linear_predictive_coefficient;
                for shift_index = 1 : dimension_index
                    object.linear_predictive_coefficient(1, shift_index + 1) = old_linear_predictive_coefficient(1, shift_index + 1) - (object.partial_autocorelation_coefficient(1, dimension_index + 1) * old_linear_predictive_coefficient(1, dimension_index - shift_index + 1));
                end
                object.linear_predictive_coefficient(1, 1) = 1;
                for autocorrelation_index = 0 : dimension_index
                    object.numerators(1, dimension_index + 1) = object.numerators(1, dimension_index + 1) + (object.linear_predictive_coefficient(1, autocorrelation_index + 1) * object.autocorrelation(dimension_index + 2 - autocorrelation_index, 1));
                end
            end
        end

        % method to display properties
        function display_properties(object)
            fprintf("----------------------------------------------\n");
            fprintf("----- Partial AutoCorrelation Coefficient ----\n");
            fprintf("autocorrelation size : (%d, %d)\n", size(object.autocorrelation));
            fprintf("order : %d\n", object.order);
            fprintf("linear_predictive_coefficient size : (%d, %d)\n", size(object.linear_predictive_coefficient));
            fprintf("partial_autocorelation_coefficient size : (%d, %d)\n", size(object.partial_autocorelation_coefficient));
            fprintf("numerators size : (%d, %d)\n", size(object.numerators));
            fprintf("denominators size : (%d, %d)\n", size(object.denominators));
            fprintf("----------------------------------------------\n\n");
        end
    end
end