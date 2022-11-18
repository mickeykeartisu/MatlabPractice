%% class to calculate Partial Autocorrelation Coefficient (PARCOR) Vocoder
classdef PartialAutocorrelationCoefficientVocoder < handle
    %% how to use : Usage
    %   1. generate PartialAutocorrelationCoefficient instance
    %       -> arguments : 
    %           ・ autocorrelation : signal autocorrelation array
    %           ・ order : analysis order (default : 30)
    %   2. if you'd like to check properties, conduct display_properties() method
    %% ---------- properties ---------- %%
    properties(Access = public)
        autocorrelation;
        order;
        output;
        synthesized_signal;
        internal_status;
    end

    %% ---------- methods ---------- %%
    methods
        %% ---------- default constructor ---------- %%
        function object = PartialAutocorrelationCoefficientVocoder(autocorrelation, order)
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
        function set.output(object, output)
            object.output = output;
        end

        % synthesized_signal setter
        function set.synthesized_signal(object, synthesized_signal)
            if length(synthesized_signal) < 1
                throw(MException("Setter:synthesized_signal", "synthesized_signal size is smaller than 1."));
            end
            object.synthesized_signal = synthesized_signal;
        end

        % internal_status setter
        function set.internal_status(object, internal_status)
            if length(internal_status) < 1
                throw(MException("Setter:internal_status", "internal_status size is smaller than 1."));
            end
            object.internal_status = internal_status;
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

        % synthesized_signal getter
        function synthesized_signal = get.synthesized_signal(object)
            synthesized_signal = object.synthesized_signal;
        end

        % internal_status getter
        function internal_status = get.internal_status(object)
            internal_status = object.internal_status;
        end

        %% ---------- usual method ---------- %%
        % method to convolute partial autocorrelation coefficient and residual error
        function convolute(object, partial_autocorrelation_coefficient_element)
            object.output = object.output + 
        end

        % method to synthesize signal
        function synthesize_signal(object, residual_error, partial_autocorrelation_coefficient)
            object.internal_status = residual_error;
            for order_index = object.order : 1
                object.convolute(partial_autocorrelation_coefficient(order_index));
            end
        end

        % method to display properties
        function display_properties(object)
            fprintf("----------------------------------------------\n");
            fprintf("- Partial AutoCorrelation Coefficient Vocoder \n");
            fprintf("autocorrelation size : (%d, %d)\n", size(object.autocorrelation));
            fprintf("order : %d\n", object.order);
            fprintf("synthesize_signal size : (%d, %d)\n", size(object.synthesized_signal));
            fprintf("internal_status size : (%d, %d)\n", size(object.internal_status));
            fprintf("output : %d\n", object.output);
            fprintf("----------------------------------------------\n\n");
        end
    end
end