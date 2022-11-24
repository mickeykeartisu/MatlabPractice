%% class to calculate Partial Autocorrelation Coefficient (PARCOR) Vocoder
classdef PartialAutocorrelationCoefficientVocoder < handle
    %% how to use : Usage
    %   1. generate PartialAutocorrelationCoefficient instance
    %       -> arguments : 
    %           ・ autocorrelation : signal autocorrelation array
    %           ・ order : analysis order (default : 30)
    %   2. if you'd like to check properties, conduct display_properties() method
    %   3. if you'd like to normalize impulse response, conduct normalize_impulse_response() method
    %% ---------- properties ---------- %%
    properties(Access = public)
        autocorrelation;    % required
        order;
        output;
        impulse_response;
        internal_status;
        partial_autocorrelation_coefficient;
    end

    %% ---------- methods ---------- %%
    methods
        %% ---------- default constructor ---------- %%
        function object = PartialAutocorrelationCoefficientVocoder(autocorrelation, order)
            object.autocorrelation = autocorrelation;   % required
            if exist("order", "var")
                object.order = order;
            else
                object.order = 30;
            end
            object.partial_autocorrelation_coefficient = PartialAutocorrelationCoefficient(object.autocorrelation, object.order);
            object.calculate_impulse_response();
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

        % output setter
        function set.output(object, outputs)
            object.output = outputs;
        end

        % impulse_response setter
        function set.impulse_response(object, impulse_response)
            if length(impulse_response) < 1
                throw(MException("Setter:impulse_response", "impulse_response is smaller than 1."));
            end
            object.impulse_response = impulse_response;
        end

        % internal_status setter
        function set.internal_status(object, internal_status)
            if length(internal_status) < 1
                throw(MException("Setter:internal_status", "internal_status size is smaller than 1."));
            end
            object.internal_status = internal_status;
        end

        % partial_autocorrelation_coefficient setter
        function set.partial_autocorrelation_coefficient(object, partial_autocorrelation_coefficient)
            if ~isobject(partial_autocorrelation_coefficient)
                throw(MException("Setter:partial_autocorrelation_coefficient", "input PartialAutocorrelationCoefficient instance."));
            end
            object.partial_autocorrelation_coefficient = partial_autocorrelation_coefficient;
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

        % output getter
        function output = get.output(object)
            output = object.output;
        end

        % impulse_response getter
        function impulse_response = get.impulse_response(object)
            impulse_response = object.impulse_response;
        end

        % internal_status getter
        function internal_status = get.internal_status(object)
            internal_status = object.internal_status;
        end

        % partial_autocorrelation_coefficient getter
        function partial_autocorrelation_coefficient = get.partial_autocorrelation_coefficient(object)
            partial_autocorrelation_coefficient = object.partial_autocorrelation_coefficient;
        end

        %% ---------- usual method ---------- %%
        % method to normalize impulse response
        function normalize_impulse_response(object)
            object.impulse_response = object.impulse_response / max(abs(object.impulse_response));
        end

        % method to convolute partial autocorrelation coefficient and residual error
        function convolute(object, partial_autocorrelation_coefficient, order_index)
            object.output = object.output + (partial_autocorrelation_coefficient(order_index) * object.internal_status(order_index));
            if order_index + 1 <= object.order
                object.internal_status(order_index + 1) = object.internal_status(order_index) - (partial_autocorrelation_coefficient(order_index) * object.output);
            end
        end

        % method to synthesize signal
        function signal = synthesize_signal(object, residual_error_element)
            object.output = residual_error_element;
            for order_index = object.order : -1 : 1
                object.convolute(object.partial_autocorrelation_coefficient.partial_autocorelation_coefficient(2 : end), order_index);
            end
            object.internal_status(1) = object.output;
            signal = object.output;
        end

        % method to calculate impulse_response
        function calculate_impulse_response(object)
            object.internal_status = zeros(1, object.order);
            object.impulse_response = zeros(size(object.autocorrelation));
            object.impulse_response(1) = object.synthesize_signal(1);
            for signal_index = 2 : length(object.autocorrelation)
                object.impulse_response(signal_index) = object.synthesize_signal(0);
            end
            object.normalize_impulse_response();
        end

        % method to display properties
        function display_properties(object)
            fprintf("----------------------------------------------\n");
            fprintf("- Partial AutoCorrelation Coefficient Vocoder \n");
            fprintf("autocorrelation size : (%d, %d)\n", size(object.autocorrelation));
            fprintf("order : %d\n", object.order);
            fprintf("internal_status size : (%d, %d)\n", size(object.internal_status));
            fprintf("outputs : %d\n", object.output);
            fprintf("impulse_response size : (%d, %d)\n", size(object.impulse_response));
            fprintf("----------------------------------------------\n\n");
        end
    end
end